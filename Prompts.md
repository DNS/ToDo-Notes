flutter, create todo list with app color support for each list.
supported colors (yellow, orange, red, green, blue, violet, gray).

The + icon button on the bottom-right to add new List. 
When the + button clicked it show:
	- It open new page to add the title, content, color. It also contain ← icon button on top-left to go back to main page. Also contain 'Save' Button on the bottom (full width). Also contain 'Delete' button bellow 'Save' button.
	- When user press ← then it automatically save the note then go back to main page.
	- When user press 'Save' button then it automatically save the note then go back to main page.
	- When user press 'Delete' button then it automatically delete the list or cancel the note creation then go back to main page.
	- When in main page, after the List added, the user can click the list and edit it (set the title, content, color again).


The ... icon button on the top-right is the hamburger menu for settings.
When ... clicked, it show: Settings, About.
When 'About' clicked, it show dialog box: Created by Obito Uchiha.

The Top-Left contain the title 'ToDo Notes'.


On the main page, the lists edges is slightly rounded.

On the main page, show only the Lists title with its corresponding  lighter color (light yellow, light orange,  light red, light green, light blue, light violet, light gray), and do not show round colored icon before the List title.
When the list edited, and show the its corresponding color to in background in lighter color (light yellow, light orange, light red, light green, light blue, light violet, light gray).
When the list edited, the content editable text field show 10 lines.

Add pre-populated sample list: List 1 (color light yellow), List 2 (light red), List 3 (light green) with content containing Lorem Ipsum ... text.

On the main page, if List is click-hold, it will show select list with checkmark, and then the 'Delete' button will show up on the bottom (full width) to delete the list if clicked, and the 'Cancel' also show below the 'Delete' button (full width).
Hide the + icon button while the list in the (click-hold) mode.
If Delete button is clicked then hide the Delete button, then show the + icon button. 
If 'Cancel'  button is clicked then cancel the selection process, hide the Delete button, hide Cancel button, then show the + icon button. 
When nothing is selected, then automatically cancel the selection process.
The Delete button on the main menu is hidden by default.




|-------------------------|
| ToDo Notes         ...  |
|                         |
| List 1                  |
| List 2                  |
| List 3                  |
|                         |
|                         |
|                         |
|                         |
|                         |
|                         |
|                         |
|                         |
|                   |---| |
|                   | + | |
|                   |---| |
|-------------------------|
