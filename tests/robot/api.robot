*** Settings ***
Library    RequestsLibrary

Suite Setup    Create Session    api    http://localhost:5000
Suite Teardown    Delete All Sessions

*** Test Cases ***
Say Hello With Name
    ${resp}=    GET    api    /hello    params=name=Jukka
    Should Be Equal As Integers    ${resp.status_code}    200
    ${json}=    To Json    ${resp.text}
    Should Be Equal    ${json["message"]}    Hello, Jukka!

Say Hello Without Name
    ${resp}=    GET    api    /hello
    Should Be Equal As Integers    ${resp.status_code}    200
    ${json}=    To Json    ${resp.text}
    Should Be Equal    ${json["message"]}    Hello, Stranger!
