*** Settings ***
Library           RequestsLibrary
Library           Collections


*** Variables ***
${BASE_URL}       http://localhost:5000

*** Settings ***
Suite Setup       Create Session    api    ${BASE_URL}
Suite Teardown    Delete All Sessions

*** Keywords ***
Response Should Have Message
    [Arguments]    ${resp}    ${expected}
    Should Be Equal As Integers    ${resp.status_code}    200
    Should Be Equal                ${resp.json()["message"]}    ${expected}

Result Should Be
    [Arguments]    ${op}    ${a}    ${b}    ${expected_as_number}
    ${resp}=    GET On Session    api    /${op}    params=a=${a}&b=${b}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${body}=    Set Variable    ${resp.json()}
    ${key}=     Set Variable If    '${op}'=='add'    sum    result
    ${value}=   Get From Dictionary    ${body}    ${key}
    Should Be Equal As Numbers    ${value}    ${expected_as_number}

Error Should Be
    [Arguments]    ${op}    ${expected_message}    ${a}=${NONE}    ${b}=${NONE}
    &{params}=    Create Dictionary
    IF    $a != None
        Set To Dictionary    ${params}    a=${a}
    END
    IF    $b != None
        Set To Dictionary    ${params}    b=${b}
    END
    ${resp}=    GET On Session    api    /${op}    params=&{params}    expected_status=400
    Should Be Equal    ${resp.json()["error"]}    ${expected_message}


*** Test Cases ***
Hello With Name
    ${resp}=    GET On Session    api    /hello    params=name=Jukka
    Response Should Have Message    ${resp}    Hello, Jukka!

Hello Without Name
    ${resp}=    GET On Session    api    /hello
    Response Should Have Message    ${resp}    Hello, Stranger!

Valid Operations
    [Template]    Result Should Be
    add         2    3    5
    subtract    7    2    5
    multiply    3    4    12
    divide      8    2    4

Invalid Inputs (Missing)
    [Template]    Error Should Be
    add         Missing query parameters 'b'                 2
    subtract    Missing query parameters 'a'                 ${NONE}    3
    multiply    Missing query parameters 'a', 'b'
    divide      Missing query parameters 'a', 'b'

Invalid Inputs (Non-numeric)
    [Template]    Error Should Be
    add         Parameters 'a' and 'b' must be numbers      x    1
    subtract    Parameters 'a' and 'b' must be numbers      foo  bar
    multiply    Parameters 'a' and 'b' must be numbers      2    xx

Divide By Zero
    [Template]    Error Should Be
    divide      Division by zero                            1    0
