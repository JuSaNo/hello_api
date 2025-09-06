*** Settings ***
Library    RequestsLibrary

*** Keywords ***
Response Should Have Message
    [Arguments]    ${resp}    ${expected}
    Should Be Equal As Integers    ${resp.status_code}    200
    Should Be Equal    ${resp.json()["message"]}    ${expected}

*** Test Cases ***
Say Hello With Name
    ${resp}=    GET    http://localhost:5000/hello    params=name=Jukka
    Response Should Have Message    ${resp}    Hello, Jukka!

Say Hello Without Name
    ${resp}=    GET    http://localhost:5000/hello
    Response Should Have Message    ${resp}    Hello, Stranger!
