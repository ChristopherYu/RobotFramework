*** Settings ***
Documentation    Scenario: verify functions of CWA page
...              Test cases:
...              1. verify page title that display county name based on selected is correct.
...              2. verify district of selected county in dropdown list are correct.
Library    SeleniumLibrary
Library    Collections
Library    DAO/TaiwanCountiesInfo.py
Library    PageObject/UI/WeatherForecastCounty.py
Library    PageObject/UI/WeatherForecastTown.py
Suite Setup    Open Browser    browser=Chrome
Suite Teardown    Close Browser

*** Variables ***

*** Test Cases ***
Select all cities and verify it's title
    [Documentation]    Scenario: 驗證頁面標題顯示城市名稱與所選縣市相同
    ...                Step 1.: 打開選擇縣市下拉選單
    ...                Step 2.: 選擇縣市
    ...                Step 3.: 驗證縣市預報後的城市名稱是否與所選擇的縣市相同
    ...                Step 4.: 重複上述步驟直到所有縣市都確認完畢
    ${main_page}=    Get Library Instance    WeatherForecastCounty
    ${counties}=    Get Counties
    Log    ${counties}
    Given Go To    ${main_page.url}
    FOR    ${county}   IN    @{counties}
        When Select Item By Value On Dropdown List    value=${county["value"]}    locator=${main_page.county_dropdown_list}
        Then Element Text Should Be    locator=${main_page.main_title}    expected=縣市預報 - ${county["name"]}
    END

Select all county and verify it's districts
    [Documentation]    Scenario: 驗證是否依照所選城市而在下拉選單正確顯示鄉鎮區
    ...                Step 1.: 選擇縣市
    ...                Step 2.: 驗證鄉鎮預報上所顯示城市為所選城市
    ...                Step 3.: 打開選擇鄉鎮
    ...                Step 4.: 選擇鄉鎮
    ...                Step 5.: 點擊確認按鈕
    ...                Step 6.: 驗證轉導畫面至鄉鎮氣象頁面
    ...                Step 7.: 驗證鄉鎮氣象頁標題顯示所選鄉鎮
    ...                Step 8.: 重複上述步驟直到所有縣市的鄉鎮都確認完畢
    ${counties}=    Get Counties
    ${county_page}=    Get Library Instance    WeatherForecastCounty
    ${town_page}=    Get Library Instance    WeatherForecastTown
    FOR    ${county}  IN    @{counties}
        Log    ${county["name"]}
        Log    ${county["value"]}
        Log    ${county["districts"]}
        FOR    ${district}    IN    @{county["districts"]}
            Log    ${district}
            Given Go To    ${county_page.url}
            When Select Item By Value On Dropdown List    value=${county["value"]}    locator=${county_page.county_of_town_dropdown_list}
            And Wait Until Element Contains    locator=${county_page.main_title}    text=${county["name"]}    timeout=30
            And Select Item By Value On Dropdown List    value=${district["value"]}    locator=${county_page.town_dropdown_list}
            And Click Element    ${county_page.confirm_button}
            And Wait For Condition	return document.readyState == "complete"
            Then Element Text Should Be    locator=${town_page.main_title}    expected=鄉鎮預報 - ${county["name"]}${district["name"]}
        END
    END


Verify weather summary
    [Documentation]    Scenario: 驗證天氣跑馬燈與彈跳視窗內文字是否符合
    ...                Step 1.: 擷取天氣跑馬燈文字(去除“看更多”字樣)
    ...                Step 2.: 打開彈跳視窗
    ...                Step 3.: 驗證彈跳視窗內的文字是否包含天氣跑馬燈(去除標點符號)
    ${main_page}    Get Library Instance    WeatherForecastCounty
    Given Go To    ${main_page.url}
    ${marquee_text}    Get Text    ${main_page.marquee}
    Log    ${marquee_text}
    When Click Element    ${main_page.marquee}
    And Wait Until Element Is Visible    ${main_page.popup}
    Then Element Text Should Be    locator=${main_page.popup_title.strip()}    expected=${marquee_text[:-3].strip()}


*** Keywords ***
select item by value on dropdown list
    [Arguments]    ${value}    ${locator}
    Click Element    ${locator}
    Select From List By Value    ${locator}    ${value}
