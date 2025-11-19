File/Preferences/Settings

Remote [WSL:Debian] => Code Spell Checker => descendre => Edit in settings.json

<img width="1164" height="685" alt="image" src="https://github.com/user-attachments/assets/5a59bc92-3af6-488c-a2f8-a7d9479e9d7b" />


### Editer settings.json
      {
          "python.defaultInterpreterPath": "/bin/python3",
      
          // Configuration de Code Spell Checker
          "cSpell.enabled": true,
          "cSpell.language": "en,fr",
          "cSpell.dictionaries": ["fr"],
          "cSpell.allowCompoundWords": true,
          "cSpell.ignorePaths": [
              "node_modules/**",
              "dist/**",
              ".git/**"
          ],
          "cSpell.ignoreRegExpList": [
              "/\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}\\b/",
              "/\\bhttps?:\\/\\/[^\\s]+\\b/"
          ],
          "cSpell.words": [
              "API",
              "NodeJS",
              "VueJS"
          ],
      
          // Dictionnaires personnalisés (actuellement vide)
          "cSpell.customDictionaries": {
              
          }
      }
