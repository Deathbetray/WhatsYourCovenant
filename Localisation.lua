local addonName, addonData = ...

local L = {}

--- Params
-- locale	- the language to localise to
-- str		- the string to localise
-- ...		- variables to insert into the localised string
addonData.LocStr = function(locale, str, ...)
	if (locale == nil) then
		locale = GetLocale()
	end
	
	if (L[str] ~= nil) then
		if (L[str][locale] ~= nil and L[str][locale] ~= "") then
			return string.format(L[str][locale], ...)
		else
			print("Missing " ..locale.. " localisation for: " ..str)
		end
	else
		print("Missing loc string: " ..str)
	end
	
	return string.format(str, ...)
end


-----------------------------
-- General
-----------------------------
L["Covenant: %s"] = {
	["enUS"] = "Covenant: %s",
	["frFR"] = "Engagement: %s",
	["deDE"] = "Bund: %s",
	["itIT"] = "Patto: %s",
	["esES"] = "Pacto: %s",
	["esMX"] = "Pacto: %s",
	["ptBR"] = "Pacto: %s",
	["ruRU"] = "Ковенант: %s",	-- courtesy of Hollicsh (Curseforge)
	["koKR"] = "계약: %s",
	["zhCN"] = "盟約: %s",
	["zhTW"] = "盟约: %s",
}


-----------------------------
-- Options Menu
-----------------------------
L["Unit Tooltip"] = {
	["enUS"] = "Unit Tooltip",
	["frFR"] = "Info-bulle de l'unité",
	["deDE"] = "Unit Tooltip",
	["itIT"] = "Descrizione comando unità",
	["esES"] = "Información sobre herramientas de la unidad",
	["esMX"] = "Información sobre herramientas de la unidad",
	["ptBR"] = "Dica de ferramenta da unidade",
	["ruRU"] = "Подсказка объекта",
	["koKR"] = "유닛 툴팁",
	["zhCN"] = "單位工具提示",
	["zhTW"] = "单位工具提示",
}

L["Show Covenant in unit's mouseover tooltip"] = {
	["enUS"] = "Show Covenant in unit's mouseover tooltip",
	["frFR"] = "Afficher l'alliance dans l'info-bulle de survol de l'unité",
	["deDE"] = "Zeigen Sie Covenant im Mouseover-Tooltip der Einheit an",
	["itIT"] = "Mostra Covenant nel tooltip del mouseover dell'unità",
	["esES"] = "Mostrar Pacto en la descripción emergente del mouse sobre la unidad",
	["esMX"] = "Mostrar Pacto en la descripción emergente del mouse sobre la unidad",
	["ptBR"] = "Mostrar Covenant na dica de mouseover da unidade",
	["ruRU"] = "Показать Ковенант во всплывающей подсказке при наведении курсора мыши",
	["koKR"] = "유닛의 마우스 오버 툴팁에 언약 표시",
	["zhCN"] = "在單位的鼠標懸停工具提示中顯示盟約",
	["zhTW"] = "在单位的鼠标悬停工具提示中显示盟约",
}

L["Contextual Tooltip (world map, groupfinder, etc.)"] = {
	["enUS"] = "Contextual Tooltip (world map, groupfinder, etc.)",
	["frFR"] = "Info-bulle contextuelle (carte du monde, chercheur de groupe, etc.)",
	["deDE"] = "Kontext-Tooltip (Weltkarte, Gruppenfinder usw.)",
	["itIT"] = "Tooltip contestuale (mappa del mondo, groupfinder, ecc.)",
	["esES"] = "Información sobre herramientas contextual (mapa mundial, buscador de grupos, etc.)",
	["esMX"] = "Información sobre herramientas contextual (mapa mundial, buscador de grupos, etc.)",
	["ptBR"] = "Dica de ferramenta contextual (mapa mundial, groupfinder, etc.)",
	["ruRU"] = "Контекстная подсказка (карта мира, поиск групп и т.д.)",		-- courtesy of Hollicsh (Curseforge)
	["koKR"] = "상황 별 툴팁 (세계지도, 그룹 파인더 등)",
	["zhCN"] = "內容相關的工具提示（世界地圖，groupfinder等）",
	["zhTW"] = "内容相关的工具提示（世界地图，groupfinder等）",
}

L["Show Covenant in contextual tooltip"] = {
	["enUS"] = "Show Covenant in contextual tooltip",
	["frFR"] = "Afficher l'alliance dans une info-bulle contextuelle",
	["deDE"] = "Zeigen Sie Covenant im Kontext-Tooltip",
	["itIT"] = "Mostra Patto nel suggerimento contestuale",
	["esES"] = "Mostrar Pacto en descripción emergente contextual",
	["esMX"] = "Mostrar Pacto en descripción emergente contextual",
	["ptBR"] = "Mostrar Covenant na dica contextual",
	["ruRU"] = "Показать Ковенант в контекстной подсказке",
	["koKR"] = "상황 별 툴팁에 언약 표시",
	["zhCN"] = "在上下文工具提示中顯示盟約",
	["zhTW"] = "在上下文工具提示中显示盟约",
}

L["Groupfinder"] = {
	["enUS"] = "Groupfinder",
	["frFR"] = "Recherche de Groupe",
	["deDE"] = "Gruppenfinder",
	["itIT"] = "Ricerca Gruppi",
	["esES"] = "Buscador de Grupos",
	["esMX"] = "Buscador de Grupos",
	["ptBR"] = "Wyszukiwarka Grup",
	["ruRU"] = "Поиск группы",
	["koKR"] = "그룹 찾기",
	["zhCN"] = "组查找器",
	["zhTW"] = "组查找器",
}

L["Show Covenant icons"] = {
	["enUS"] = "Show Covenant icons",
	["frFR"] = "Afficher les icônes d'alliance",
	["deDE"] = "Bündnissymbole anzeigen",
	["itIT"] = "Mostra le icone del patto",
	["esES"] = "Mostrar iconos de Pacto",
	["esMX"] = "Mostrar iconos de Pacto",
	["ptBR"] = "Pokaż ikony Przymierza",
	["ruRU"] = "Показать значки Ковенанта",
	["koKR"] = "성약 아이콘 표시",
	["zhCN"] = "显示契约图标",
	["zhTW"] = "显示契约图标",
}

L["Database"] = {
	["enUS"] = "Database",
	["frFR"] = "Base de données",
	["deDE"] = "Datenbank",
	["itIT"] = "Banca dati",
	["esES"] = "Base de datos",
	["esMX"] = "Base de datos",
	["ptBR"] = "Base de dados",
	["ruRU"] = "База данных",
	["koKR"] = "데이터 베이스",
	["zhCN"] = "數據庫",
	["zhTW"] = "数据库",
}

L["View opposing faction's Covenant"] = {
	["enUS"] = "View opposing faction's Covenant",
	["frFR"] = "Voir le Pacte de la faction adverse",
	["deDE"] = "Sehen Sie sich den Bund der gegnerischen Fraktion an",
	["itIT"] = "Visualizza il Patto della fazione avversaria",
	["esES"] = "Ver el Pacto de la facción contraria",
	["esMX"] = "Ver el Pacto de la facción contraria",
	["ptBR"] = "Veja o Pacto da facção oposta",
	["ruRU"] = "Просмотр Ковенанта противоположной фракции",	-- courtesy of Hollicsh (Curseforge)
	["koKR"] = "상대 진영의 서약보기",
	["zhCN"] = "查看反對派的盟約",
	["zhTW"] = "查看反对派的盟约",
}

L["Generate a personal database (based on seeing players use abilities)"] = {
	["enUS"] = "Generate a personal database (based on seeing players use abilities)",
	["frFR"] = "Générez une base de données personnelle (basée sur la façon dont les joueurs utilisent leurs capacités)",
	["deDE"] = "Generieren Sie eine persönliche Datenbank (basierend darauf, wie Spieler Fähigkeiten einsetzen)",
	["itIT"] = "Genera un database personale (basato sul vedere i giocatori usare le abilità)",
	["esES"] = "Genere una base de datos personal (basada en ver a los jugadores usar habilidades)",
	["esMX"] = "Genere una base de datos personal (basada en ver a los jugadores usar habilidades)",
	["ptBR"] = "Gere um banco de dados pessoal (com base em ver os jogadores usarem as habilidades)",
	["ruRU"] = "Создать личную базу данных (основываясь на том, как игроки используют способности)",	-- courtesy of Hollicsh (Curseforge)
	["koKR"] = "개인 데이터베이스 생성 (플레이어가 능력을 사용하는 것을 기준으로)",
	["zhCN"] = "生成個人數據庫（基於玩家的使用能力）",
	["zhTW"] = "生成个人数据库（基于玩家的使用能力）",
}

L["Usability"] = {
	["enUS"] = "Usability",
	["frFR"] = "Convivialité",
	["deDE"] = "Benutzerfreundlichkeit",
	["itIT"] = "Usabilità",
	["esES"] = "Usabilidad",
	["esMX"] = "Usabilidad",
	["ptBR"] = "Usabilidade",
	["ruRU"] = "Удобство использования",
	["koKR"] = "유용성",
	["zhCN"] = "易用性",
	["zhTW"] = "易用性",
}

L["Colourise the covenant names"] = {
	["enUS"] = "Colourise the covenant names",
	["frFR"] = "Colorez les noms des alliances",
	["deDE"] = "Färbe die Namen des Bundes",
	["itIT"] = "Colora i nomi delle alleanze",
	["esES"] = "Colorea los nombres del pacto",
	["esMX"] = "Colorea los nombres del pacto",
	["ptBR"] = "Colorir os nomes da aliança",
	["ruRU"] = "Окрасить имена Ковенантов",	-- courtesy of Hollicsh (Curseforge)
	["koKR"] = "언약 이름을 색칠하십시오",
	["zhCN"] = "為盟約名稱上色",
	["zhTW"] = "为盟约名称上色",
}

L["Select Colour"] = {
	["enUS"] = "Select Colour",
	["frFR"] = "Sélectionnez la couleur",
	["deDE"] = "Wählen Sie Farbe",
	["itIT"] = "Seleziona il colore",
	["esES"] = "Seleccionar color",
	["esMX"] = "Seleccionar color",
	["ptBR"] = "Wybierz kolor",
	["ruRU"] = "Выбрать цвет",
	["koKR"] = "색상 선택",
	["zhCN"] = "選擇顏色",
	["zhTW"] = "选择颜色",
}

L["Reset Covenant Colours to Default"] = {
	["enUS"] = "Reset Covenant Colours to Default",
	["frFR"] = "Réinitialiser les couleurs par défaut",
	["deDE"] = "Farben auf Standard zurücksetzen",
	["itIT"] = "Ripristina i colori predefiniti",
	["esES"] = "Restablecer colores a los valores predeterminados",
	["esMX"] = "Restablecer colores a los valores predeterminados",
	["ptBR"] = "Zresetuj kolory do domyślnych",
	["ruRU"] = "Сбросить цвета по умолчанию",
	["koKR"] = "색상을 기본값으로 재설정",
	["zhCN"] = "將顏色重置為默認值",
	["zhTW"] = "将颜色重置为默认值",
}

-- Template
--L[""] = {
--	["enUS"] = "",
--	["frFR"] = "",
--	["deDE"] = "",
--	["itIT"] = "",
--	["esES"] = "",
--	["esMX"] = "",
--	["ptBR"] = "",
--	["ruRU"] = "",
--	["koKR"] = "",
--	["zhCN"] = "",
--	["zhTW"] = "",
--}
