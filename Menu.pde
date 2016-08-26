//TILE SPIKES ONTO GAP, OPTIONS LIGHT UP 7/30
// MENU BACKGROUND, ANT, ADD SYMBOLS. 
//MAKE SURE NOTHING SPAWNS OVER SPIKES, AND IF THEY DO, PUT IT 100 PIXELS ABOVE. 7/31

class Menu {

  String title, start, instruct, cred, subMenuTitle, subMenuContent;
  int titleArr, startArr, instructArr, credArr, subMenuArr, contentArr;
  color textColor, subTextColor;

  Menu(color textCol, String t, String s, String i, String c, int ta, int sa, int ia, int ca)
  {
    title = t;
    start = s;
    instruct = i;
    cred = c;
    titleArr = ta; 
    startArr = sa;
    instructArr = ia;
    credArr = ca;
    textColor = textCol;
  }

  Menu(color c, String title, String content, int arr, int carr) {
    subMenuTitle = title;
    subMenuContent = content;
    subMenuArr = arr;
    contentArr = carr;
    subTextColor = c;
  }




  void display() {
    textAlign(CENTER);
    fill(textColor);
    text(title, width/2, titleArr);
    text(start, width/2, startArr);
    text(instruct, width/2, instructArr);
    text(cred, width/2, credArr);
  }


  void displaySubMenu() {
    textAlign(CENTER);
    fill(subTextColor);
    text(subMenuTitle, width/2, subMenuArr);
    textFont(f, 16);
    text(subMenuContent, 200, contentArr - 100, 400, 400);
    textFont(f, 36); 
    text("BACK", 100, 500);
  }
}

