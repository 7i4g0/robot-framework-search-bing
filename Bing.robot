*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    String
Library    Process
Library    DateTime

*** Variables ***
${EdgeDriverPath}    D:/User/Downloads/edgedriver_win64/msedgedriver.exe
${BingURL}           https://www.bing.com
${RewardsURL}        https://rewards.bing.com/
${TwitterKeywords}   random_words.txt
${TotalWords}        30
${SleepTime}         16m
${i}                 0

*** Test Cases ***
# @TODO Abrir o Rewards e clicar nos cards
#     Open Browser    ${RewardsURL}    edge    executable_path=${EdgeDriverPath}
#     Maximize Browser Window
#     ${element} =    Get Element    css:.nome-da-classe
#     Element Attribute Value Should Be    ${element}    class    minha-classe
#     Click Element    ${element}
#     mee-rewards-daily-set-item-content

Fazer requisição e gerar ${TotalWords} palavras novas
    ${process_output} =    Run Process    python    generate_keywords.py    ${TotalWords}
    Log    Output do Processo:
    Log    ${process_output.stdout}
    Log    ${process_output.stderr}

Abrir o Edge e fazer buscas no Bing com palavras geradas
    Open Browser    ${BingURL}    edge    executable_path=${EdgeDriverPath}
    Maximize Browser Window
    ${file_contents}    Get File    ${TwitterKeywords}
    @{keywords}    Split To Lines    ${file_contents}
    FOR    ${keyword}    IN    @{keywords}
      ${i}=    Evaluate    ${i} + 1
      Log To Console    \n- ${i}: Buscando por "${keyword}"
      Input Text    id=sb_form_q    ${keyword}
      Submit Form
      Wait Until Element Is Visible    id=b_results
      ${currentTime}=    Get Time
      ${nextSearchTime}=    Add Time To Date    ${currentTime}    ${SleepTime}
      Capture Page Screenshot    bing_search_${i}.png
      Log To Console    - Busca por "${keyword}" concluída (${currentTime}).
      Log To Console    - Aguarde por ${SleepTime} para a próxima busca...
      Log To Console    - Próxima busca será às ${nextSearchTime}\n
      Sleep    ${SleepTime}
    END
    Close Browser
