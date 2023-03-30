import processing.core.*;
import processing.data.*;
import java.util.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.text.*;

// Global Variables
LinkedHashMap<String, Scene> scenesMap;
String activeSceneName;
boolean paused;
boolean flagged = false;
boolean complete = false;
int difficulty = -1; //Note: <0 is not in game, 0 is easy, 1 is medium, 2 is hard
String word;
String name = "";
JSONObject writeToBoard;
int wrongGuesses;
boolean wroteToLBoard = false;
boolean nameAsked = false;
PFont TimesNewRoman;
boolean debug = true;
int frameSinceGameEnd = 0;
JFrame frame = new JFrame();
JPanel panel = new JPanel();
int clockTime;

final PVector[] steps = new PVector[] {new PVector(1690, 1030), new PVector(1560, 895), new PVector(1430, 785), new PVector(1300, 680), new PVector(1170, 570), new PVector(1040, 460)};

final String[] easywords = {
  "All",
  "And",
  "Boy",
  "Book",
  "Call",
  "Car",
  "City",
  "Here",
  "Make",
  "Find",
  "End",
  "Eat",
  "Drink",
  "Food",
  "Girl",
  "Mother",
  "Father",
  "School",
  "House",
  "Name",
  "Meal",
  "Lunch",
  "Work",
  "Blue",
  "Red",
  "Take",
  "This",
  "That",
  "Bear",
  "Cat",
  "Dog",
  "One",
  "Two",
  "Three",
  "Hand",
  "Head",
  "Leg",
  "Heart",
  "Arm",
  "Small",
  "Big",
  "Day",
  "Night",
  "Month",
  "Year",
  "Down",
  "Left",
  "Front",
  "Back",
  "Look",
  "Time"
};

final String[] mediumwords = {
  "Above",
  "Acute",
  "Alive",
  "Alone",
  "Angry",
  "Aware",
  "Awful",
  "Basic",
  "Black",
  "Blind",
  "Brave",
  "Brief",
  "Broad",
  "Brown",
  "Cheap",
  "Chief",
  "Civil",
  "Clean",
  "Clear",
  "Close",
  "Crazy",
  "Daily",
  "Dirty",
  "Early",
  "Empty",
  "Equal",
  "Exact",
  "Extra",
  "Faint",
  "False",
  "Fifth",
  "Final",
  "First",
  "Fresh",
  "Front",
  "Funny",
  "Giant",
  "Grand",
  "Great",
  "Green",
  "Gross",
  "Happy",
  "Harsh",
  "Heavy",
  "Human",
  "Ideal",
  "Inner",
  "Joint",
  "Large",
  "Legal",
  "Level",
  "Light",
  "Local",
  "Loose",
  "Lucky",
  "Magic",
  "Major",
  "Minor",
  "Moral",
  "Nasty",
  "Naval",
  "Other",
  "Outer",
  "Plain",
  "Prime",
  "Prior",
  "Proud",
  "Quick",
  "Quiet",
  "Rapid",
  "Ready",
  "Right",
  "Roman",
  "Rough",
  "Round",
  "Royal",
  "Rural",
  "Sharp",
  "Sheer",
  "Short",
  "Silly",
  "Sixth",
  "Small",
  "Smart",
  "Solid",
  "Sorry",
  "Spare",
  "Steep",
  "Still",
  "Super",
  "Sweet",
  "Thick",
  "Third",
  "Tight",
  "Total",
  "Tough",
  "Upper",
  "Upset",
  "Urban",
  "Usual",
  "Vague",
  "Valid",
  "Vital",
  "White",
  "Whole",
  "Wrong",
  "Young"
};

final String[] hardwords = {
  "abruptly",
  "absurd",
  "abyss",
  "affix",
  "askew",
  "avenue",
  "awkward",
  "axiom",
  "azure",
  "bagpipes",
  "bandwagon",
  "banjo",
  "bayou",
  "beekeeper",
  "bikini",
  "blitz",
  "blizzard",
  "boggle",
  "bookworm",
  "boxcar",
  "boxful",
  "buckaroo",
  "buffalo",
  "buffoon",
  "buxom",
  "buzzard",
  "buzzing",
  "buzzwords",
  "caliph",
  "cobweb",
  "cockiness",
  "croquet",
  "crypt",
  "curacao",
  "cycle",
  "daiquiri",
  "dirndl",
  "disavow",
  "dizzying",
  "duplex",
  "dwarves",
  "embezzle",
  "equip",
  "espionage",
  "euouae",
  "exodus",
  "faking",
  "fishhook",
  "fixable",
  "fjord",
  "flapjack",
  "flopping",
  "flyby",
  "foxglove",
  "frazzled",
  "frizzled",
  "fuchsia",
  "funny",
  "gabby",
  "galaxy",
  "galvanize",
  "gazebo",
  "giaour",
  "gizmo",
  "glowworm",
  "glyph",
  "gnarly",
  "gnostic",
  "gossip",
  "haiku",
  "haphazard",
  "hyphen",
  "icebox",
  "injury",
  "ivory",
  "ivy",
  "jackpot",
  "jaundice",
  "jaywalk",
  "jazziest",
  "jazzy",
  "jelly",
  "jigsaw",
  "jinx",
  "jiujitsu",
  "jockey",
  "jogging",
  "joking",
  "jovial",
  "joyful",
  "juicy",
  "jukebox",
  "jumbo",
  "kayak",
  "kazoo",
  "keyhole",
  "khaki",
  "kilobyte",
  "kiosk",
  "kitsch",
  "kiwifruit",
  "klutz",
  "knapsack",
  "larynx",
  "lengths",
  "lucky",
  "luxury",
  "lymph",
  "marquis",
  "matrix",
  "megahertz",
  "microwave",
  "mnemonic",
  "mystify",
  "naphtha",
  "nightclub",
  "nowadays",
  "numbskull",
  "nymph",
  "onyx",
  "ovary",
  "oxidize",
  "oxygen",
  "pajama",
  "peekaboo",
  "phlegm",
  "pixel",
  "pizazz",
  "pneumonia",
  "polka",
  "pshaw",
  "psyche",
  "puppy",
  "puzzling",
  "quartz",
  "queue",
  "quips",
  "quixotic",
  "quiz",
  "quizzes",
  "quorum",
  "rhubarb",
  "rhythm",
  "rickshaw",
  "schnapps",
  "scratch",
  "shiv",
  "snazzy",
  "sphinx",
  "spritz",
  "squawk",
  "staff",
  "strength",
  "stretch",
  "stymied",
  "subway",
  "swivel",
  "syndrome",
  "topaz",
  "twelfth",
  "unknown",
  "unworthy",
  "unzip",
  "uptown",
  "vaporize",
  "voodoo",
  "vortex",
  "walkway",
  "waltz",
  "wave",
  "wavy",
  "waxy",
  "wellspring",
  "wheezy",
  "whizzing",
  "whomever",
  "wimpy",
  "wizard",
  "woozy",
  "wyvern",
  "xylophone",
  "yachtsman",
  "yippee",
  "yoked",
  "youthful",
  "yummy",
  "zephyr",
  "zigzag",
  "zilch",
  "zipper",
  "zodiac",
  "zombie"
};

//------------------------------------------
// System methods
// Configures program setting
void Settings() {
}


// Runs on Startup
void setup()
{
  // Configure window
  fullScreen();
  surface.setResizable(false);
  surface.setTitle("H_ng M_n");

  // initialize variables
  scenesMap = new LinkedHashMap<String, Scene>();

  //Main Scene, the first scene when the game is loaded
  scenesMap.put("Main Scene", new Scene("Main Scene", loadImage("Background.png")));
  scenesMap.get("Main Scene").objects.put("Start Button", new Sprite("StartButton.png", width/2, height/8*9/4));
  scenesMap.get("Main Scene").objects.put("Leader Button", new Sprite("BigLeaderButton.png", width/2, height/8*5));
  scenesMap.get("Main Scene").objects.put("Logo", new Sprite("Hangmanlogo.png", width/2, height/8*7));
  pauseMenuBuilder("Main Scene", false);

  //Level Scene, the scene shown when start is pressed
  scenesMap.put("Level Scene", new Scene("Level Scene", loadImage("Background.png")));
  scenesMap.get("Level Scene").objects.put("Easy Button", new Sprite("EasyButton.png", width/2, height/8*2));
  scenesMap.get("Level Scene").objects.put("Medium Button", new Sprite("MediumButton.png", width/2, height/8*4));
  scenesMap.get("Level Scene").objects.put("Hard Button", new Sprite("HardButton.png", width/2, height/8*6));
  pauseMenuBuilder("Level Scene", true);

  //Game Scene, the scene shown when game is running
  makeGameScene();

  //Leaderboard changed to a JFrame
  /*//Leader Scene, the scene shown at leaderboard
   scenesMap.put("Leader Scene", new Scene("Leader Scene", loadImage("LeaderBoardBackground.png")));
   pauseMenuBuilder("Leader Scene", true);*/

  //Failed Scene, the scene shown when you fail
  scenesMap.put("Failed Scene", new Scene("Failed Scene", loadImage("Failed.png")));
  pauseMenuBuilder("Failed Scene", true);

  //Victory Scene, the scene shown when you win
  scenesMap.put("Victory Scene", new Scene("Victory Scene", loadImage("VictoryScene.png")));
  pauseMenuBuilder("Victory Scene", true);

  activeSceneName = "Main Scene";
  paused = false;
  TimesNewRoman = createFont("Times New Roman", 24);
}

// Runs every frame
void draw()
{
  try {
    scenesMap.getOrDefault(activeSceneName, new Scene("Default Scene", loadImage("DefaultBackground.png"))).draw();
    if (wrongGuesses >= 6)
    {
      activeSceneName = "Failed Scene";
    }
    if (complete)
    {
      activeSceneName = "Victory Scene";
    }
    if (activeSceneName.equals("Victory Scene"))
    {
      frameSinceGameEnd++;
    }
    if(activeSceneName.equals("Game Scene"))
    {
      //Displays the scoreboard
      fill(100);
      textFont(createFont("Arial",30,true), 30);
      text("ScoreBoard: ", width/26*22.5, height/9*2.5);
      text("Time: " + (currentTimeMillis() - clockTime)/1000, width/26*23, height/9*3);
      text("Wrong Guesses: " + (wrongGuesses), width/26*22, height/9*3.5);
    }
    if (frameSinceGameEnd > 3 && activeSceneName.equals("Victory Scene"))
    {
      int timeStamp = currentTimeMillis();
      name = JOptionPane.showInputDialog("Input Your Name Here");
      //Writes the inputed name and their score, and the difficulty played on to the leaderboard
      if(debug)
      {
          System.out.println(name.replace("\n", "").replace("\r", ""));
      }
      writeToBoard = new JSONObject();
      writeToBoard.setString("name", name.isBlank() ? "No Name" : name.replace("\n", "").replace("\r", ""));
      writeToBoard.setInt("score", ((clockTime - timeStamp)/1000 + wrongGuesses * (difficulty)));
      if(debug)
      {
          System.out.println(((clockTime - timeStamp)/1000 + wrongGuesses * difficulty));
      }
      switch (difficulty) {
      case 0:
        writeToBoard.setString("difficulty", "easy");
        break;
      case 1:
        writeToBoard.setString("difficulty", "medium");
        break;
      case 2:
        writeToBoard.setString("difficulty", "hard");
        break;
      }
      JSONArray leaderArray = loadJSONArray("PassGames.json");
      leaderArray.append(writeToBoard);
      saveJSONArray(leaderArray, "PassGames.json");
      wroteToLBoard = true;
      nameAsked = true;
      goHome();
    }
  }
  catch (NullPointerException ex) {
    //System.out.println(ex.toString() + " has happended");
  }
  catch (IllegalArgumentException ex) {
    //ex.printStackTrace();
  }
  catch (RuntimeException ex) {
    //ex.printStackTrace();
  }
}

void mouseClicked()
{
  try {
    if (paused) {
      pauseHandle();
      if (scenesMap.containsKey(activeSceneName) &&
        (scenesMap.get(activeSceneName).objects.get("Pause Button").isClicked() || scenesMap.get(activeSceneName).objects.get("Resume Button").isClicked()))
      {
        unpause();
      }
    } else
    {
      if (activeSceneName.equals("Main Scene"))
      {
        if (scenesMap.get(activeSceneName).objects.get("Start Button").isClicked())
        {
          activeSceneName = "Level Scene";
        }
        if (scenesMap.get(activeSceneName).objects.get("Leader Button").isClicked())
        {
          saveJSONArray(sortJSONArray(loadJSONArray("PassGames.json"), "score"), "PassGames.json");
          //Creates leaderboard in a seperate window
          frame = new JFrame();
          panel = new JPanel();

          frame.setTitle("Leaderboard");
          frame.setSize(550, 600);
          frame.setResizable(false);
          frame.setLayout(new BorderLayout());
          panel.setLayout(new GridLayout(1, 4));

          JTextPane leaderboard = new JTextPane();
          leaderboard.setEditable(false);
          leaderboard.setFocusable(false);
          
          SimpleAttributeSet centerAlign = new SimpleAttributeSet();
          StyleConstants.setAlignment(centerAlign, StyleConstants.ALIGN_CENTER);

          SimpleAttributeSet leftAlign = new SimpleAttributeSet();
          StyleConstants.setAlignment(leftAlign, StyleConstants.ALIGN_LEFT);

          SimpleAttributeSet rightAlign = new SimpleAttributeSet();
          StyleConstants.setAlignment(rightAlign, StyleConstants.ALIGN_RIGHT);

          
          JSONArray leaderArray = loadJSONArray("PassGames.json");
          // JSONArray sorting, aquired from https://stackoverflow.com/questions/19543862/how-can-i-sort-a-jsonarray-in-java 
          JSONArray sortedLeaderArray = new JSONArray();

          ArrayList<JSONObject> jsonValues = new ArrayList<JSONObject>();
          for (int i = 0; i < leaderArray.size(); i++) {
              jsonValues.add(leaderArray.getJSONObject(i));
          }
          Collections.sort(jsonValues, new Comparator<JSONObject>() {

          private static final String KEY_NAME = "score";

          @Override
          public int compare(JSONObject a, JSONObject b) {
              int valA = 0;
              int valB = 0;

              try {
                      valA = Integer.parseInt(String.valueOf(a.get(KEY_NAME)));
                      valB = Integer.parseInt(String.valueOf(b.get(KEY_NAME)));
                  } 
                  catch (Exception e) {
                      //do Nothing
                  }

                  return valA < valB ? -1 : (valA == valB ? 0 : 1);
              }
          });

          for (int i = 0; i < leaderArray.size(); i++) {
              sortedLeaderArray.append(jsonValues.get(i));
          }
          //Writes the current leaderboard values to the leaderboard
          for (int i = 0; i < leaderArray.size(); i++) {
              leaderboard.getStyledDocument().setParagraphAttributes(0, 0, leftAlign, true);
              leaderboard.getStyledDocument().insertString(leaderboard.getStyledDocument().getLength(), String.format("%-25.25s", (i+1) + ": "), null);
              leaderboard.getStyledDocument().setParagraphAttributes(0, 0, centerAlign, true);
              leaderboard.getStyledDocument().insertString(leaderboard.getStyledDocument().getLength(), String.format("%-12.12s", sortedLeaderArray.getJSONObject(i).getString("name")), null);
              leaderboard.getStyledDocument().setParagraphAttributes(0, 0, centerAlign, true);
              leaderboard.getStyledDocument().insertString(leaderboard.getStyledDocument().getLength(), String.format("%12.12s", sortedLeaderArray.getJSONObject(i).getString("difficulty")), null);
              leaderboard.getStyledDocument().setParagraphAttributes(0, 0, rightAlign, true);
              leaderboard.getStyledDocument().insertString(leaderboard.getStyledDocument().getLength(), String.format("%25.25s", -sortedLeaderArray.getJSONObject(i).getInt("score")) + "\n", null);
          }

          JScrollPane leaderboardScroll = new JScrollPane(leaderboard);
          JLabel labelPlace = new JLabel("Place", SwingConstants.CENTER);
          panel.add(labelPlace);
          JLabel labelName = new JLabel("Name", SwingConstants.CENTER);
          panel.add(labelName);
          JLabel labelDiff = new JLabel("Difficulty", SwingConstants.CENTER);
          panel.add(labelDiff);
          JLabel labelScore = new JLabel("Score", SwingConstants.CENTER);
          panel.add(labelScore);
          panel.validate();
          frame.add(panel, BorderLayout.NORTH);
          panel = new JPanel();
          panel.setLayout(new BorderLayout());
          panel.add(leaderboardScroll);
          panel.validate();
          frame.add(panel, BorderLayout.CENTER);
          frame.setVisible(true);
        }
      }
      if (activeSceneName.equals("Level Scene"))
      {
        if (scenesMap.get(activeSceneName).objects.get("Easy Button").isClicked()) {
          buildGameRun(0);
        }
        if (scenesMap.get(activeSceneName).objects.get("Medium Button").isClicked()) {
          buildGameRun(1);
        }
        if (scenesMap.get(activeSceneName).objects.get("Hard Button").isClicked()) {
          buildGameRun(2);
        }
      }
      if (activeSceneName.equals("Game Scene"))
      {
        if (scenesMap.get(activeSceneName).objects.get("Help Button").isClicked()) {
          scenesMap.get(activeSceneName).objects.get("Help Text").hidden = !scenesMap.get(activeSceneName).objects.get("Help Text").hidden;
        }
      }
      if (activeSceneName.equals("Victory Scene"))
      {
      }
      if (scenesMap.containsKey(activeSceneName) && (scenesMap.get(activeSceneName).objects.get("Pause Button") != null
        && scenesMap.get(activeSceneName).objects.get("Pause Button").isClicked()))
      {
        pause();
      }
    }
  }
  catch (NullPointerException ex) {
    //System.out.println(ex.toString() + " Has happened");
  }
  catch (Exception ex) {
    //ex.printStackTrace();
  }
}

void keyTyped()
{
  if (keyCode == java.awt.event.KeyEvent.VK_ESCAPE)
  {
    exit();
  }
  if (scenesMap.containsKey(activeSceneName) && keyCode == java.awt.event.KeyEvent.VK_TAB)
  {
    if (paused)
    {
      unpause();
    } else
    {
      pause();
    }
  }
  if (activeSceneName.equals("Victory Scene"))
  {
  }
  if (activeSceneName.equals("Game Scene"))
  {
    if ((int(key) > 64 & int(key) < 91) | (int(key) > 96 & int(key) < 123))
    {
      boolean isWrong = true;
      boolean hasComplete = true;
      for (String objKey : scenesMap.get(activeSceneName).objects.keySet())
      {
        if (objKey.contains("Letter"))
        {
          if (objKey.substring(7).equalsIgnoreCase(String.valueOf(key)))
          {
            scenesMap.get(activeSceneName).objects.get(objKey).currentState = "LetterState";
            isWrong = false;
          }
          if (!scenesMap.get(activeSceneName).objects.get(objKey).currentState.equals("LetterState"))
          {
            hasComplete = false;
          }
        }
      }
      complete = hasComplete;
      if (isWrong)
      {
        wrongGuesses++;
        scenesMap.get(activeSceneName).objects.get("Stick Figure").transform(steps[clamp(wrongGuesses, 0, 5)]);
      }
    }
  }
}

//-------------------------------------------
// other code
void pauseMenuBuilder(String toScene, boolean needHome)
{
  scenesMap.get(toScene).objects.put("Pause Button", new Sprite("PauseButton.png", width/11, height/11));
  scenesMap.get(toScene).objects.put("Pause Background", new Sprite("PauseBackground.png", width/2, height/4*2));
  scenesMap.get(toScene).objects.get("Pause Background").hidden = true;
  scenesMap.get(toScene).objects.get("Pause Background").overlay = true;
  if (needHome)
  {
    scenesMap.get(toScene).objects.put("Home Button", new Sprite("HomeButton.png", width/2, height/4*3*1/2));
    scenesMap.get(toScene).objects.get("Home Button").hidden = true;
    scenesMap.get(toScene).objects.get("Home Button").overlay = true;
  }
  scenesMap.get(toScene).objects.put("Resume Button", new Sprite("ResumeButton.png", width/2, height/4*2));
  scenesMap.get(toScene).objects.get("Resume Button").hidden = true;
  scenesMap.get(toScene).objects.get("Resume Button").overlay = true;
  scenesMap.get(toScene).objects.put("Quit Button", new Sprite("QuitButton.png", width/2, height/4*5/2));
  scenesMap.get(toScene).objects.get("Quit Button").hidden = true;
  scenesMap.get(toScene).objects.get("Quit Button").overlay = true;
}

void pause()
{
  paused = true;
  scenesMap.get(activeSceneName).objects.get("Pause Background"). hidden = false;
  scenesMap.get(activeSceneName).objects.get("Resume Button").hidden = false;
  scenesMap.get(activeSceneName).objects.get("Quit Button").hidden = false;
  if (scenesMap.get(activeSceneName).objects.get("Home Button") != null)
  {
    scenesMap.get(activeSceneName).objects.get("Home Button"). hidden = false;
  }
}

void unpause()
{
  paused = false;
  scenesMap.get(activeSceneName).objects.get("Pause Background").hidden = true;
  scenesMap.get(activeSceneName).objects.get("Resume Button").hidden = true;
  scenesMap.get(activeSceneName).objects.get("Quit Button").hidden = true;
  if (scenesMap.get(activeSceneName).objects.get("Home Button") != null)
  {
    scenesMap.get(activeSceneName).objects.get("Home Button").hidden = true;
  }
}

void pauseHandle()
{
  if (scenesMap.get(activeSceneName).objects.get("Quit Button").isClicked())
  {
    exit();
  }
  if (scenesMap.get(activeSceneName).objects.get("Home Button") != null)
  {
    if (scenesMap.get(activeSceneName).objects.get("Home Button").isClicked())
    {
      unpause();
      goHome();
    }
  }
}

void goHome()
{
  difficulty = -1;
  flagged = false;
  wrongGuesses = 0;
  complete = false;
  wroteToLBoard = false;
  nameAsked = false;
  frameSinceGameEnd = 0;
  activeSceneName = "Main Scene";
  //need to reset game scene so old games are removed
  makeGameScene();
}

void buildGameRun(int lDifficulty)
{
  String word = "";
  clockTime = currentTimeMillis();
  switch (lDifficulty) {
  case 0:
    do
    {
      word = easywords[int(random(0, easywords.length))];
    } while (word.length() > 8);
    break;
  case 1:
    do
    {
      word = mediumwords[int(random(0, mediumwords.length))];
    } while (word.length() > 8);
    break;
  case 2:
    do
    {
      word = hardwords[int(random(0, hardwords.length))];
    } while (word.length() > 8);
    break;
  }
  difficulty = lDifficulty;
  for (int i = 0; i < word.length(); i++) {
    scenesMap.get("Game Scene").objects.put("Letter" + i + word.substring(i, i + 1),
      new LetterBuilders().makeSpot(word.substring(i, i + 1)).setCordPass(
      int(float(width) / 2 - 136 / 2 * word.length() + 136 * i),
      int(950.0 / 1080 * height)));
  }
  if (debug)
  {
    System.out.println(word);
  }
  activeSceneName = "Game Scene";
}

void makeGameScene()
{
  scenesMap.put("Game Scene", new Scene("Game Scene", loadImage("InGameBackground.png")));
  scenesMap.get("Game Scene").objects.put("Stick Figure", new Sprite("StickFigureBase.png", steps[0]));
  scenesMap.get("Game Scene").objects.get("Stick Figure").pic.resize(87, 136);
  scenesMap.get("Game Scene").objects.put("Help Button", new Sprite("QMark.png", width/10*9 + 5, height/9*1));
  scenesMap.get("Game Scene").objects.put("Help Text", new Sprite("HelpText.png", width/2 + 15, height/2));
  scenesMap.get("Game Scene").objects.get("Help Text").hidden = true;
  scenesMap.get("Game Scene").objects.get("Help Text").overlay = true;
  pauseMenuBuilder("Game Scene", true);
}


int clamp(int value, int min, int max) {
  return Math.max(min, Math.min(max, value));
}

//Sorts JSON from least to greatest
JSONArray sortJSONArray(JSONArray array, final String KeyToSort) {
  JSONArray tempArray = new JSONArray();
  //Converts the JSONArray to a Collection/List to sort it
  java.util.List<JSONObject> listArray = new ArrayList<JSONObject>();
  for (int i = 0; i < array.size(); i++)
  listArray.add(array.getJSONObject(i));
  Collections.sort(listArray, new Comparator<JSONObject>() {
    //Nested int function to compare the values between 2 objects 
    public int compare(JSONObject jsonObjectA, JSONObject jsonObjectB) {
        int comparator = 0;
        try
        {
            int keyA = jsonObjectA.getInt(KeyToSort);
            int keyB = jsonObjectB.getInt(KeyToSort);
            comparator = Integer.compare(keyA, keyB);
        }
        catch (NullPointerException ex) {
          //System.out.println(ex.toString() + " has happended");
        }
        catch (IllegalArgumentException ex) {
          //ex.printStackTrace();
        }
        catch (RuntimeException ex) {
          //ex.printStackTrace();
        }
        return comparator;
    }
  });
  for (int i = 0; i < listArray.size(); i++) {
    tempArray.append(listArray.get(i));
  }
  return tempArray;
}

//Converts System.currentTimeMillis() to an integer
int currentTimeMillis() {
    return (int)(System.currentTimeMillis() % Integer.MAX_VALUE);
}

// Classes

// Sccene class is used to handle every scene
class Scene
{
  String name;
  PImage backgroundImg;
  LinkedHashMap<String, Sprite> objects;

  Scene(String lname, PImage backgroundImg, LinkedHashMap objects)
  {
    this.name = lname;
    this.backgroundImg = backgroundImg;
    this.objects = objects;
  }

  Scene(String lname, PImage backgroundImg)
  {
    this.name = lname;
    this.backgroundImg = backgroundImg;
    this.objects = new LinkedHashMap<String, Sprite>();
  }

  Scene(String lname)
  {
    this(lname, null);
  }

  Scene()
  {
    this("unnamed scene", null, new LinkedHashMap<String, Sprite>(0));
  }

  void draw()
  {
    backgroundImg.resize(width, height);
    background(backgroundImg);
    for (Sprite object : objects.values())
    {
      object.display();
    }
    for (Sprite object : objects.values())
    {
      object.displayOverlay();
    }
  }
}

class LetterBuilders
{
  //must be cap
  Sprite makeSpot(String letter)
  {
    Sprite sp = new Sprite("BlankSpot.png");
    PImage imgA = loadImage(letter.toUpperCase() + "Spot.png");
    PImage imgB = loadImage("BlankSpot.png");
    sp.multState = true;
    sp.currentState = "BlankState";
    sp.allStates.put("BlankState", imgB);
    sp.allStates.put("LetterState", imgA);
    return sp;
  }
}

// Sprite class handles should be used to handle non static objects
// Ported from an old project
class Sprite {

  // Image of the sprite
  PImage pic;

  // where the sprite x y is respectively
  int x, y;


  // unused
  float change_x, change_y;

  int boundsT, boundsB, boundsL, boundsR;

  boolean hidden = false;
  boolean multState = false;
  boolean overlay = false;

  String currentState = "";

  HashMap<String, PImage> allStates = new HashMap<String, PImage>();

  // constructor for Sprite with options to configure file, scale and coordinate
  Sprite(PImage pimage, int x, int y) {
    // initialize image of sprite
    pic = pimage;

    // set coordinates
    this.x = x;
    this.y = y;

    this.boundsT = y - pic.height / 2;
    this.boundsB = y + pic.height / 2;
    this.boundsL = x - pic.width / 2;
    this.boundsR = x + pic.width / 2;
  }

  // constructor with filename  parameter only.
  // In the constructor, use this() to call the previous constructor.
  Sprite(String filename) {
    // calls construtor above with x, y at 0
    this(loadImage(filename), 0, 0);
  }

  //Loads based on filename and location
  Sprite(String filename, int x, int y) {
    this(loadImage(filename), x, y);
  }

  //Loads based on filename and location
  Sprite(String filename, PVector vec) {
    this(filename, int(vec.x), int(vec.y));
  }

  // constructor with file parameter only.
  // In the constructor, use this() to call the previous constructor.
  Sprite(PImage pimage) {
    // calls construtor above with x, y at 0
    this(pimage, 0, 0);
  }

  Sprite(PImage pimage, PVector vec) {
    // calls construtor above with x, y at 0
    this(pimage, int(vec.x), int(vec.y));
  }

  // default Constructor, should not be used for anything other than subclass initializing superclasses
  Sprite() {
    this("");
  }

  // displays non overlay sprite
  void display() {
    // this is the image display function
    if (!hidden & !overlay) {
      if (multState) {
        image(allStates.get(currentState), x - allStates.get(currentState).width/2, y - allStates.get(currentState).height/2);
      } else
      {
        image(pic, x-pic.width/2, y-pic.height/2);
      }
    }
  }

  //displays overlay sprites
  void displayOverlay()
  {
    // this is the image display function
    if (!hidden & overlay) {
      if (multState) {
        image(allStates.get(currentState), x - allStates.get(currentState).width/2, y - allStates.get(currentState).height/2);
      } else
      {
        image(pic, x - pic.width / 2, y - pic.height / 2);
      }
    }
  }

  // moves sprite to location (newx, newy)
  void transform(int newx, int newy) {
    x = newx;
    y = newy;
  }

  // moves sprite to location specified by Point p
  void transform(PVector p) {
    transform(int(p.x), int(p.y));
  }

  Sprite setCordPass(int x, int y) {
    transform(x, y);
    return this;
  }

  PImage getImgScaled(int x, int y) {
    PImage img = pic;
    img.resize(img.width*x, img.height*y);
    return img;
  }

  boolean isClicked()
  {
    if (boundsL < mouseX && mouseX < boundsR && mouseY > boundsT && boundsB > mouseY && !hidden)
    {
      return true;
    }
    return false;
  }
}