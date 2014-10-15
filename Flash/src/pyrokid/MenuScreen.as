package pyrokid {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.ui.Keyboard;
    import flash.utils.ByteArray;
    import ui.*;
    import physics.*;
    import pyrokid.entities.*;
    import pyrokid.tools.*;
    
    /**
     * ...
     * @author Evan Niederhoffer
     */
    public class MenuScreen extends Sprite {
        
        public static const STATE_START:int = 0;
        public static const STATE_GAME_OVER:int = 1;
        public static const STATE_PAUSE:int = 2;
        
        private var curr_state:int;
        private var main:Main;
        private var didPlayerWin:Boolean;
        
        public var showStartMenuFunc:Function;
        public var startGameFunc:Function;
        public var quitGameFunc:Function;
        
        public var go_to_next_screen:Boolean = false;
        
        public function MenuScreen(game_state:int, mainObj:Main, didPlayerWin:Boolean = false):void {
            
            curr_state = game_state;
            main = mainObj;
            this.didPlayerWin = didPlayerWin;
            
            displayMenu();
        
        }
        
        private function generateStartGameFunc(levelRecipe:ByteArray):Function {
            return function():void {
                startGameFunc(levelRecipe);
            }
        }
        
        public function displayMenu():void {
            switch (curr_state) {
                case STATE_START: 
                    var welcomeText:TextField = new TextField();
                    welcomeText.width = Main.MainStage.stageWidth;
                    welcomeText.height = Main.MainStage.stageHeight;
                    welcomeText.text = String("Welcome to PyroKid!");
                    welcomeText.y = Main.MainStage.stageHeight / 3 - welcomeText.textHeight / 2;
                    
                    var format:TextFormat = new TextFormat();
                    format.align = TextFormatAlign.CENTER;
                    format.font = "Arial";
                    format.size = 15;
                    welcomeText.setTextFormat(format);
                    
                    addChild(welcomeText);
                    addChild(new LevelEditorButton(generateStartGameFunc(null), 80, 40, 100, Main.MainStage.stageHeight / 2, ["Choose Level"], [LevelEditorButton.upColor]));
                    addChild(new LevelEditorButton(generateStartGameFunc(Embedded.levelAaronTest), 80, 40, 100 + (100), Main.MainStage.stageHeight / 2, ["Easy"], [LevelEditorButton.upColor]));
                    addChild(new LevelEditorButton(generateStartGameFunc(Embedded.level2b), 80, 40, 100 + (300), Main.MainStage.stageHeight / 2, ["Medium"], [LevelEditorButton.upColor]));
                    addChild(new LevelEditorButton(generateStartGameFunc(Embedded.level3b), 80, 40, 100 + (500), Main.MainStage.stageHeight / 2, ["Hard"], [LevelEditorButton.upColor]));
                    
                    break;
                    
                case STATE_GAME_OVER: 
                    var byeText:TextField = new TextField();
                    byeText.width = Main.MainStage.stageWidth;
                    var playerWinText:String = didPlayerWin ? "\n\nYou Won!" : "You Lost!";
                    byeText.text = String("Game Over!\n\n" + playerWinText);
                    byeText.y = Main.MainStage.stageHeight / 3 - byeText.textHeight / 2;
                    
                    var format2:TextFormat = new TextFormat();
                    format2.align = TextFormatAlign.CENTER;
                    format2.font = "Arial";
                    format2.size = 15;
                    byeText.setTextFormat(format2);
                    
                    addChild(byeText);
                    
                    addChild(new LevelEditorButton(showStartMenuFunc, 160, 40, Main.MainStage.stageWidth / 2, Main.MainStage.stageHeight / 2, ["Go Back to Main Menu"], [LevelEditorButton.upColor]));
                    
                    break;
            }
        }
    }

}