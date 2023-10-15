*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    String
Library    Process

*** Variables ***
${EdgeDriverPath}    D:\User\Downloads\msedgedriver.exe
${BingURL}           https://www.bing.com
${TwitterKeywords}   random_words.txt
${TotalWords}        30
${i}                 0

*** Test Cases ***
Fazer requisição e gerar palavras novas
    ${process_output} =    Run Process    python    generate_keywords.py    ${TotalWords}
    Log    Output do Processo:
    Log    ${process_output.stdout}
    Log    ${process_output.stderr}

Abrir o Edge e fazer buscas no Bing com palavras do Twitter
    Open Browser    ${BingURL}    edge    executable_path=${EdgeDriverPath}
    Maximize Browser Window
    ${file_contents}    Get File    ${TwitterKeywords}
    @{keywords}    Split To Lines    ${file_contents}
    FOR    ${keyword}    IN    @{keywords}
      ${i}=    Evaluate    ${i} + 1
      Input Text    id=sb_form_q    ${keyword}
      Submit Form
      Wait Until Element Is Visible    id=b_results
      sleep    2s
      Capture Page Screenshot    bing_search_${i}.png
    END
    Close Browser
