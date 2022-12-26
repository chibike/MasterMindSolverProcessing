import processing.sound.*;

// https://www.archimedes-lab.org/mastermind.html

int activePageIndex;
Scene activePage;
Scene[] availablePages;

void setup() 
{
    size(1600, 900);
    
    activePageIndex = -1;
    availablePages = new Scene[2];
    availablePages[0] = new TitlePage(this);
    availablePages[1] = new GamePage(this);

    nextPage();

    frameRate(15);

    fill(255);
}

void draw() 
{
    activePage.Draw();

    // text(mouseX, 40, 120);
    // text(mouseY, 40, 150);
}

void mousePressed() 
{
    activePage.MousePressed(mouseX, mouseY);
}

void mouseReleased() 
{
    activePage.MouseReleased();
}

void mouseMoved() 
{
    activePage.MouseMoved(mouseX, mouseY);
}

void nextPage()
{
    if (activePage != null)
    {
        activePage.Stop();
    }

    activePageIndex += 1;
    activePage = availablePages[activePageIndex % availablePages.length];
    activePage.Start();
}

public class TitlePage extends Scene
{
    TitlePage(PApplet parent)
    {
        super(parent, "assests/allthat.wav", "assests/title-screen-01.png");

        Buttons.add(
            new ImageButton(
                300, 638,
                _scale,
                "assests/start-button-01.png", 
                "assests/start-button-02.png", 
                "assests/start-button-03.png"
            )
        );
    }

    public void MouseMoved(int x, int y)
    {
        var btn = Buttons.get(0);

        if (btn.IsOver()) {
            btn.ButtonState = ButtonStateEnum.HOVER;
        } else {
            btn.ButtonState = ButtonStateEnum.DEFAULT;
        }
    }

    public void MousePressed(int x, int y)
    {
        var btn = Buttons.get(0);

        if (btn.IsOver()) {
            btn.ButtonState = ButtonStateEnum.CLICKED;
            nextPage();
        } else {
            btn.ButtonState = ButtonStateEnum.DEFAULT;
        }
    }

    public void MouseReleased()
    {
        var btn = Buttons.get(0);
        btn.ButtonState = ButtonStateEnum.DEFAULT;
    }
}

public class GamePage extends Scene
{
    public int ActiveDeckIndex;
    public DeckObject ActiveDeck;
    public GameMaster Solver;
    public AnimationObject[] Animations;
    public ImageLibrary Images;
    public DeckManager Decks;
    public SimpleImageButton RestartButton;

    private VolumeButton _volumeBtn;
    private int _activeAnimationIndex;
    private int _lastChangeMinute;

    GamePage(PApplet parent)
    {
        super(parent, "assests/allthat.wav", "assests/main-page-01.png");

        Images = new ImageLibrary(_scale);
        Animations = new AnimationObject[6];

        RestartButton = new SimpleImageButton(
            _scale,
            7, 100,
            "assests/reload-button.png"
        );

        Animations[0] = new AnimationObject(
            "assests/animations/animation-01/frame-",
            0, 8,
            1,
            150, 750, 0.6
        );

        Animations[1] = new AnimationObject(
            "assests/animations/animation-02/frame-",
            0, 7,
            1,
            150, 750, 0.6
        );

        Animations[2] = new AnimationObject(
            "assests/animations/animation-03/frame-",
            0, 8,
            1,
            150, 750, 0.6
        );

        Animations[3] = new AnimationObject(
            "assests/animations/animation-04/frame-",
            0, 35,
            1,
            150, 750, 0.6
        );

        Animations[4] = new AnimationObject(
            "assests/animations/animation-05/frame-",
            0, 24,
            1,
            150, 750, 0.6
        );

        Animations[5] = new AnimationObject(
            "assests/animations/animation-06/frame-",
            0, 88,
            1,
            150, 750, 0.6
        );

        Buttons.add(
            _volumeBtn = new VolumeButton(
                50, 800,
                _scale,
                "assests/volume-on-01.png", 
                "assests/volume-on-02.png", 
                "assests/volume-on-03.png", 
                "assests/volume-off-01.png", 
                "assests/volume-off-02.png", 
                "assests/volume-off-03.png"
            )
        );

        _activeAnimationIndex = (int)random(0, Animations.length - 1);
        _lastChangeMinute = minute();
    }

    public void Start()
    {
        super.Start();

        Restart();
    }

    public void Restart()
    {
        Decks = new DeckManager(_scale, Images, 383, 284, 92);
        Solver = new GameMaster();

        ActiveDeckIndex = 0;
        ActiveDeck = Decks.DeckObjects[ActiveDeckIndex++];
        ActiveDeck.Position01Id = Solver.CurrentGuess.Get(0);
        ActiveDeck.Position02Id = Solver.CurrentGuess.Get(1);
        ActiveDeck.Position03Id = Solver.CurrentGuess.Get(2);
        ActiveDeck.Position04Id = Solver.CurrentGuess.Get(3);
        ActiveDeck.IsActive = true;
    }

    public void MouseMoved(int x, int y)
    {
        var btn = Buttons.get(0);

        if (btn.IsOver()) {
            btn.ButtonState = ButtonStateEnum.HOVER;
        } else {
            btn.ButtonState = ButtonStateEnum.DEFAULT;
        }
    }

    public void MousePressed(int x, int y)
    {
        var btn = Buttons.get(0);

        if (btn.IsOver()) {
            btn.ButtonState = ButtonStateEnum.CLICKED;

            var volumeButton = (VolumeButton)btn;

            if (volumeButton.IsMusicOn)
            {
                StopMusic();
                volumeButton.IsMusicOn = false;
            } else {
                StartMusic();
                volumeButton.IsMusicOn = true;
            }
            
        } else {
            btn.ButtonState = ButtonStateEnum.DEFAULT;
        }

        if (ActiveDeck.IsOverColouredScore()) 
        {
            ActiveDeck.ColouredScoreIndicator.Score = (ActiveDeck.ColouredScoreIndicator.Score + 1) % 5;
        } else if (ActiveDeck.IsOverWhiteScore()) {
            ActiveDeck.WhiteScoreIndicator.Score = (ActiveDeck.WhiteScoreIndicator.Score + 1) % 5;
        } else if (ActiveDeck.IsOverNextButton()) {
            if (Solver.RunOnce(new Score(ActiveDeck.ColouredScoreIndicator.Score, ActiveDeck.WhiteScoreIndicator.Score)))
            {
                if (ActiveDeckIndex < Decks.DeckObjects.length)
                {
                    ActiveDeck.IsActive = false;
                    ActiveDeck.IsCompleted = true;

                    ActiveDeck = Decks.DeckObjects[ActiveDeckIndex++];
                    ActiveDeck.Position01Id = Solver.CurrentGuess.Get(0);
                    ActiveDeck.Position02Id = Solver.CurrentGuess.Get(1);
                    ActiveDeck.Position03Id = Solver.CurrentGuess.Get(2);
                    ActiveDeck.Position04Id = Solver.CurrentGuess.Get(3);
                    ActiveDeck.IsActive = true;
                }
            }
        }

        if (RestartButton.IsOver())
        {
            Restart();
        }
    }

    public void MouseReleased()
    {
        var btn = Buttons.get(0);
        btn.ButtonState = ButtonStateEnum.DEFAULT;
    }

    public void Draw()
    {
        super.Draw();

        Decks.Draw();

        if (!_volumeBtn.IsMusicOn)
        {
            return;
        }

        Animations[_activeAnimationIndex].Draw();
        if (abs(minute() - _lastChangeMinute) > 2)
        {
            NextAnimation();
        }

        RestartButton.Draw();
    }

    public void NextAnimation()
    {
        _lastChangeMinute = minute();
        _activeAnimationIndex = (_activeAnimationIndex + 1) % Animations.length;
    }
}
