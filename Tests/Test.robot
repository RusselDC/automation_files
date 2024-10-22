*** Settings ***

Library  ../Library/Users.py
Library  ../Library/RandomNumber.py
Library  ../Library/UsState.py
Library  ../Library/RandomDate.py
Library    SeleniumLibrary
Library    Collections

Variables  ../Variables/variables.py

Suite Setup  Launch Browser
Suite Teardown  Close Browser


*** Variables ***


*** Test Cases ***

My First Test Case
    fetch data
    Login Users    Demo    Demo
    Go To Link    Customers
    Go To Add Identity Modal
    ${user_length}  Get Length    ${USERS}
    Set Suite Variable  ${USER_LENGTH}    ${user_length}
    
    FOR  ${i}  IN RANGE  0  ${user_length}
        Go To Link    Customers
        Go To Add Identity Modal
        Add Users    ${USERS}[${i}]
    END
    
    Go To Link    Customers
    Wait Until Element Is Visible    //tbody//tr[2]
    Get All names
    Display All names
    Sleep  5s
My Second Test Case
    Check Orders List Count


*** Keywords ***

Launch Browser
    [Arguments]    ${url}=https://marmelab.com/react-admin-demo
    ${options}  Set Variable  add_argument("--start-maximized")
    Open Browser  ${url}  chrome  remote_url=192.168.49.1:4444  options=${options}

Input Text
    [Arguments]  ${locator}  ${value}
    SeleniumLibrary.Input Text    ${locator}    ${value}

Login Users
    [Arguments]  ${user}  ${password}
    Input Text    name:username    ${user}
    Input Text    name:password    ${password}
    Click Button    //button

Go To Link
    [Arguments]  ${link}
    Click Element    //a[text()="${link}"]
    Wait Until Element Is Visible    //tbody//tr

fetch data
    ${users}  Get Users Via Api
    Set Suite Variable     ${USERS}  ${users}

Go To Add Identity Modal
    Click Element    //a[@aria-label="Create"]
    Wait Until Element Is Visible    ${identity_txt_firstName}
    Sleep  1s

Add Users
    [Arguments]  ${user}
    ${firstName}  Evaluate  " ".join("${user['name']}".split()[:-1]).strip()
    ${lastName}  Evaluate  " ".join("${user['name']}".split()[-1:]).strip()
    ${number}  Get Random Number
    ${password}  Set Variable  ${firstName}${number}  
    ${state}  Get Us State
    ${bdate}  Get Random Date
     

    ${address}  Set Variable  ${user['address']['suite']} ${user['address']['street']}
    Input Text    ${identity_txt_firstName}  ${firstName}
    Input Text    ${identity_txt_lastName}   ${lastName}
    Input Text    ${identity_txt_email}      ${user['email']}
    Input Date    ${identity_txt_bday}    ${bdate}
    Input Text    ${identity_txt_address}    ${address}
    Input Text    ${identity_txt_city}    ${user['address']['city']}
    Input Text    ${identity_txt_state}    ${state}
    Input Text    ${identity_txt_zip}    ${user['address']['zipcode']}
    Input Password    ${identity_txt_password}    ${password}
    Input Password    ${identity_txt_confirm_password}    ${password}
    Click Button    ${identity_btn_save}
    Sleep  2s

Input Date
    [Arguments]    ${locator}    ${date}
    Click Element At Coordinates    ${locator}    0    0
    Press Keys    None    ${date}

Get All names
    ${Web_Elems}  Get WebElements    //tbody//tr
    ${elems_len}    Get Length    ${Web_Elems}
    Log To Console    ${elems_len}
    ${names_list}  Create List
    
    FOR  ${i}  IN RANGE  1  ${elems_len}+1
        ${locator}  Set Variable  (//tbody//tr[${i}]/td[2])
        ${text}  Get Text  ${locator}
        #${status}  Run Keyword And Return Status  Page Should Contain Element  ${locator}//img
        ${text}  Evaluate   r"""${text}""".replace("\\n", "").strip()[1:]
            

        Append To List  ${names_list}  ${text}
    END

    Set Suite Variable  ${NAMES_LIST}  ${names_list}

Display All names
    ${NAMES_LIST_LENGTH}=    Get Length    ${NAMES_LIST}
    ${orders_list}  Create List

    FOR    ${i}    IN RANGE    0    ${NAMES_LIST_LENGTH}
        IF  ${i} == 0
            Log To Console   --------------------------------------
            Log To Console    All Created Users Are Displayed :D
            Log To Console   --------------------------------------
        END

        

        IF    ${i} <= ${USER_LENGTH}
            ${header}    Set Variable    Test Created User
        ELSE
            ${header}    Set Variable    Existing User
        END
        ${last_seen}  Get Text    //tbody//tr[${i+1}]//td[3]
        ${orders}    Get Text    //tbody//tr[${i+1}]//td[4]
        ${total_spent}    Get Text    //tbody//tr[${i+1}]//td[5]
        ${lastest_purchase}    Get Text    //tbody//tr[${i+1}]//td[6]
        ${news}    Get Text    //tbody//tr[${i+1}]//td[7]
        ${segment}  Get Text  //tbody//tr[${i+1}]//td[8]
        
        IF  ${orders} == 0
            Append To List    ${orders_list}    ${NAMES_LIST}[${i}]
        END

        Set Suite Variable    ${ORDERS_LIST}    ${orders_list}
        
        
        Log To Console    -------- USER ${i+1} --------
        Log To Console    ${header} : ${NAMES_LIST}[${i}]
        Log To Console    Last Seen : ${last_seen}
        Log To Console    Orders : ${orders}
        Log To Console    Total Spent : ${total_spent}
        Log To Console    Latest Purchase : ${lastest_purchase}
        Log To Console    News : ${news}
        Log To Console    Segment : ${segment}
        Log To Console    ------------------------------
    END

Check Orders List Count
    ${zero_orders_count}  Get Length  ${ORDERS_LIST}

    IF  ${zero_orders_count} >= 1
        Fail    Users with zero orders found: ${ORDERS_LIST}
    END





    
    


    
