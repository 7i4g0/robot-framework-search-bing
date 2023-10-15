import requests
import sys

# Obtenha os argumentos da linha de comando
params = sys.argv

totalWords = params[1]

def get_random_words(num_words):
    words = []
    url = f"https://random-word-api.herokuapp.com/word?number={num_words}"

    try:
        response = requests.get(url)
        if response.status_code == 200:
            words = response.json()
    except Exception as e:
        print(f"Erro ao buscar palavras: {e}")

    return words

if __name__ == "__main__":
    num_words = totalWords
    random_words = get_random_words(num_words)

    with open("random_words.txt", "w") as file:
        for word in random_words:
            file.write(word + "\n")

    print(f"{num_words} palavras aleatórias foram salvas em 'random_words.txt'.")
