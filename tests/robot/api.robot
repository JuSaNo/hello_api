*** Settings ***
Library    RequestsLibrary

*** Variables ***
${BASE_URL}    http://localhost:5000

*** Settings ***
Suite Setup       Create Session    api    ${BASE_URL}
Suite Teardown    Delete All Sessions

*** Keywords ***
Response Should Have Message
    [Arguments]    ${resp}    ${expected}
    Should Be Equal As Integers    ${resp.status_code}    200
    Should Be Equal    ${resp.json()["message"]}    ${expected}

*** Test Cases ***
Say Hello With Name
    ${resp}=    GET On Session    api    /hello    params=name=Jukka
    Response Should Have Message    ${resp}    Hello, Jukka!

Say Hello Without Name
    ${resp}=    GET On Session    api    /hello
    Response Should Have Message    ${resp}    Hello, Stranger!

Add With Valid Numbers
    ${resp}=    GET On Session    api    /add    params=a=2&b=3
    Should Be Equal As Integers    ${resp.status_code}    200
    Should Be Equal As Numbers     ${resp.json()["sum"]}    5

Add Missing Parameter
    ${resp}=    GET On Session    api    /add    params=a=2    expected_status=400
    Should Be Equal    ${resp.json()["error"]}    Missing query parameters 'a' and/or 'b'

Add Non-Numeric Parameter
    ${resp}=    GET On Session    api    /add    params=a=x&b=1    expected_status=400
    Should Be Equal    ${resp.json()["error"]}    Parameters 'a' and 'b' must be numbers