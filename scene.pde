import processing.sound.*;

public enum ButtonStateEnum
{
  DEFAULT,
  HOVER,
  CLICKED
}

public class ImageButton
{
    public int X, Y, Width, Height;
    public PImage DefaultImage, HoverImage, ClickedImage;
    public ButtonStateEnum ButtonState = ButtonStateEnum.DEFAULT;

    public ImageButton(int x, int y, float scale, String img1, String img2, String img3)
    {
        X = x;
        Y = y;

        DefaultImage = loadImage(img1);
        HoverImage = loadImage(img2);
        ClickedImage = loadImage(img3);

        Width = (int)(DefaultImage.width * scale);
        Height = (int)(DefaultImage.height * scale);

        ButtonState = ButtonStateEnum.DEFAULT;
    }

    public void Draw()
    {
        switch (ButtonState)
        {
            case DEFAULT:
                image(DefaultImage, X, Y, Width, Height);
                break;

            case HOVER:
                image(HoverImage, X, Y, Width, Height);
                break;

            case CLICKED:
                image(ClickedImage, X, Y, Width, Height);
                break;
        }
    }

    public boolean IsOver()
    {
        if (
            mouseX >= X
            && mouseX <= X + Width
            && mouseY >= Y 
            && mouseY <= Y + Height
        )
        {
            return true;
        } else {
            return false;
        }
    }
}

public class Scene
{
    protected float _scale, _width, _height;

    SoundFile BackgroundMusic;
    PImage BackgroundImage;

    ArrayList<ImageButton> Buttons;

    Scene(PApplet parent, String music, String image)
    {
        Buttons = new ArrayList<ImageButton>();

        BackgroundMusic = new SoundFile(parent, music);
        BackgroundImage = loadImage(image);

        float xScale = (float)width / BackgroundImage.width;
        float yScale = (float)height / BackgroundImage.height;
        _scale = max(xScale, yScale);

        _width = (int)(_scale * BackgroundImage.width);
        _height = (int)(_scale * BackgroundImage.height);
    }

    public void Start()
    {
        StartMusic();
    }

    public void Stop()
    {
        StopMusic();
    }

    public void StartMusic()
    {
        BackgroundMusic.loop();
    }

    public void StopMusic()
    {
        BackgroundMusic.pause();
    }

    public void Draw()
    {
        image(BackgroundImage, 0, 0, _width, _height);

        for (int i=0; i<Buttons.size(); i++)
        {
            var btn = Buttons.get(i);
            btn.Draw();
        }
    }

    public void MouseMoved(int x, int y)
    {

    }

    public void MousePressed(int x, int y)
    {

    }

    public void MouseReleased()
    {

    }
}

public class VolumeButton extends ImageButton
{
    public boolean IsMusicOn;
    public ImageButton ToggleMusicOffButton;
    public ImageButton ToggleMusicOnButton;

    VolumeButton(int x, int y, float scale, String img1, String img2, String img3, String img4, String img5, String img6)
    {
        super(x, y, scale, img1, img2, img3);

        IsMusicOn = true;
        ToggleMusicOffButton = new ImageButton(x, y, scale, img1, img2, img3);
        ToggleMusicOnButton = new ImageButton(x, y, scale, img4, img5, img6);
    }

    public void Draw()
    {
        if (IsMusicOn)
        {
            ToggleMusicOffButton.ButtonState = ButtonState;
            ToggleMusicOffButton.Draw();
        }
        else
        {
            ToggleMusicOnButton.ButtonState = ButtonState;
            ToggleMusicOnButton.Draw();
        }
    }
}

public class AnimationObject
{
    public int X, Y, Width, Height;
    public String BaseName;
    public int StartIndex, EndIndex, IndexIncrement;
    public PImage[] Sequence;

    private int _index;

    AnimationObject(String baseName, int start, int end, int increment, int x, int y, float scale)
    {
        X = x;
        Y = y;
        EndIndex = end;
        StartIndex = start;
        IndexIncrement = increment;
        BaseName = baseName;

        Sequence = new PImage[end - start];
        for (int i=0; i<Sequence.length; i++)
        {
            Sequence[i] = loadImage(
                BaseName + i + ".png"
            );
        }

        Width = (int)(Sequence[0].width * scale);
        Height = (int)(Sequence[0].height * scale);

        _index = 0;
    }

    public void Draw()
    {
        image(Sequence[_index], X, Y, Width, Height);
        _index = (_index + IndexIncrement) % Sequence.length;
    }
}