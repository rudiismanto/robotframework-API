*** Settings ***
Library    RequestsLibrary
Library    DateTime
Library    Collections

*** Variables ***
${BASE_URL}    https://api.restful-api.dev
${ENDPOINT}    /objects

*** Test Cases ***
POST --> https://api.restful-api.dev/objects
    [Documentation]    Send Req Payload with value based on timestamp

    # Ambil nilai dari waktu sekarang
    ${HHmm}=    Get Current Date    result_format=%H%M
    ${DDMM}=    Get Current Date    result_format=%d%m
    ${YYYY}=    Get Current Date    result_format=%Y

    Log To Console    HHmm: ${HHmm}, DDMM: ${DDMM}, YYYY: ${YYYY}

    # Dictionary Headers
    ${headers}=    Create Dictionary    Content-Type=application/json

    # Dictionary Payload without name
    ${data}=    Create Dictionary
    ...    year=${HHmm}
    ...    price=${DDMM}
    ...    CPU model=cpu aja
    ...    Hard disk size=${YYYY}

    # Dictonary payload include name 
    ${payload}=    Create Dictionary
    ...    name=This is rudi test
    ...    data=${data}

    # Send Post Request
    Create Session    restful    ${BASE_URL}
    ${response}=    Post On Session    restful    ${ENDPOINT}    json=${payload}
    Log To Console    Status: ${response.status_code}
    Log To Console    Body: ${response.text}

    # Pick Reponse 
    ${resp_json}=    Set Variable    ${response.json()}
    ${resp_data}=    Set Variable    ${resp_json['data']}

    # Assertion
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${resp_json}    id
    Log To Console    Object ID: ${resp_json['id']}
    Should Be Equal As Strings    ${resp_json['name']}    ${payload['name']}    name not match!
    Should Be Equal As Strings    ${resp_data['year']}    ${data['year']}    year not match!
    Should Be Equal As Strings    ${resp_data['price']}   ${data['price']}   price not match!
    Should Be Equal As Strings    ${resp_data['CPU model']}   ${data['CPU model']}   CPU model not match!
    Should Be Equal As Strings    ${resp_data['Hard disk size']}   ${data['Hard disk size']}   Hard disk size not match!