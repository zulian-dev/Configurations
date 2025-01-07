from textual.app import App, ComposeResult
from textual.containers import Container, VerticalScroll
from textual.widgets import Static, Checkbox, Button, Footer, Header, Static


import os

import subprocess



languages = {
    "markdown": {"enabled": False, "icon": "", "color": "blue"},
    "elixir": {"enabled": False, "icon": "", "color": "purple"},
    "javascript": {"enabled": False, "icon": "", "color": "yellow"},
    "html": {"enabled": False, "icon": "", "color": "orange"},
    "css": {"enabled": False, "icon": "", "color": "blue"},
    "golang": {"enabled": False, "icon": "", "color": "blue", "ligatures":["security"]},
    "rust": {"enabled": False, "icon": "", "color": "orange"},
    "java": {"enabled": False, "icon": "", "color": "red"},
    "lua": {"enabled": False, "icon": "", "color": "blue"},
    "bash": {"enabled": False, "icon": "", "color": "gray"},
    "gdscript": {"enabled": False, "icon": "", "color": "blue"},
    "clojure": {"enabled": False, "icon": "", "color": "green"},
    "php": {"enabled": False, "icon":"", "color": "purple", "ligatures":["html", "css", "javascript", "security"]}, 
    "zig": {"enabled": False, "icon": "", "color": "orange"},
    "security": {"enabled": True, "icon": "󰒃", "color": "green"},
    "none": {"enabled": False, "icon": "󰢤", "color": "gray"},
}

selectedOptions = []

class LanguageSelectorApp(App):
    CSS_PATH = "style.tcss"

    def compose(self) -> ComposeResult:
        """Compõe a interface da aplicação."""
        yield Header("Selecione as linguagens de programação que deseja usar:") 

        for lang in languages:
            yield Checkbox(
                "[" + languages[lang]["color"] + "] " 
                    + languages[lang]["icon"] + " " 
                    + lang.capitalize(),
                id=lang,
                classes="box"
            )
            
        yield Button("Ok", id="ok_button")
        yield Button("Fechar", id="close_button")
        yield Footer()
        

    def on_mount(self) -> None:
        """Configura a interface ao iniciar."""
        self.query_one("#ok_button").focus()

    def on_checkbox_changed(self, event: Checkbox.Changed) -> None:
        """Atualiza a lista de opções selecionadas quando uma checkbox muda."""
        if event.checkbox.value:
            if event.checkbox.id not in selectedOptions:
                selectedOptions.append(event.checkbox.id)
               
        else:
            if event.checkbox.id in selectedOptions:
                selectedOptions.remove(event.checkbox.id)

        self.process_ligatures(event.checkbox.id, event.checkbox.value)

    def process_ligatures(self, paramlang, isChecked): 
        if languages[paramlang].get("ligatures"):
            for lang in languages[paramlang]["ligatures"]:
                checkbox = self.query_one(f"#{lang}", Checkbox)
                
                if isChecked and lang not in selectedOptions:
                    selectedOptions.append(lang)
                    checkbox.value = True
                
                else:
                    selectedOptions.remove(lang) 
                    checkbox.value = False

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "ok_button":
            self.exit(
                self.format_output(selectedOptions)
            )
        elif event.button.id == "close_button":
            self.exit()

    def format_output(self, selectedOptions):
        formated = ",".join(selectedOptions).lower()
        return formated

if __name__ == "__main__" :
    retorno = LanguageSelectorApp().run()
    os.environ["NVIMLANG"] = retorno
    subprocess.run(["/opt/homebrew/bin/nvim"]) 
