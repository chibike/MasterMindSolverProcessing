import java.util.HashMap;

public class ScaledImage
{
    int Width, Height;
    PImage Image;

    ScaledImage(String image, float scale)
    {
        Image = loadImage(image);
        Width = (int)(Image.width * scale);
        Height = (int)(Image.height * scale);
    }

    public void Draw(int x, int y)
    {
        image(Image, x, y, Width, Height);
    }

    public boolean IsOver(int x, int y)
    {
        if (
            mouseX >= x
            && mouseX <= x + Width
            && mouseY >= y 
            && mouseY <= y + Height
        )
        {
            return true;
        } else {
            return false;
        }
    }
}

public class ImageLibrary
{
    ScaledImage Deck01Image, Deck02Image;
    ScaledImage Orb01Image, Orb02Image, Orb03Image, Orb04Image, Orb05Image, Orb06Image;

    ImageLibrary(float scale)
    {
        Deck01Image = new ScaledImage(
            "assests/deck-01.png",
            scale
        );

        Deck02Image = new ScaledImage(
            "assests/deck-02.png",
            scale
        );

        Orb01Image = new ScaledImage(
            "assests/orb-01.png",
            scale
        );

        Orb02Image = new ScaledImage(
            "assests/orb-02.png",
            scale
        );

        Orb03Image = new ScaledImage(
            "assests/orb-03.png",
            scale
        );

        Orb04Image = new ScaledImage(
            "assests/orb-04.png",
            scale
        );

        Orb05Image = new ScaledImage(
            "assests/orb-05.png",
            scale
        );

        Orb06Image = new ScaledImage(
            "assests/orb-06.png",
            scale
        );
    }
}

public class DeckObject
{
    public int Id, X, Y;
    public ImageLibrary Images;
    public boolean IsCompleted, IsActive;
    public int Position01Id, Position02Id, Position03Id, Position04Id;
    public ScoreIndicatorButton ColouredScoreIndicator, WhiteScoreIndicator;
    public SimpleImageButton NextButton;

    DeckObject(float scale, ImageLibrary images, int id, int x, int y)
    {
        Id = id;
        X = x;
        Y = y;
        Images = images;
        IsCompleted = false;
        IsActive = false;
        Position01Id = -1;
        Position02Id = -1;
        Position03Id = -1;
        Position04Id = -1;

        // Position01Id = (int)random(1, 7);
        // Position02Id = (int)random(1, 7);
        // Position03Id = (int)random(1, 7);
        // Position04Id = (int)random(1, 7);

        ColouredScoreIndicator = new ScoreIndicatorButton(
            scale,
            "assests/score-coloured-01.png",
            "assests/score-coloured-02.png",
            "assests/score-coloured-03.png",
            "assests/score-coloured-04.png",
            "assests/score-coloured-05.png"
        );

        WhiteScoreIndicator = new ScoreIndicatorButton(
            scale,
            "assests/score-white-01.png",
            "assests/score-white-02.png",
            "assests/score-white-03.png",
            "assests/score-white-04.png",
            "assests/score-white-05.png"
        );

        NextButton = new SimpleImageButton(
            scale,
            "assests/next-button.png"
        );
    }

    public void Draw()
    {
        if (IsCompleted || IsActive)
        {
            Images.Deck02Image.Draw(X, Y);
        }
        else
        {
            Images.Deck01Image.Draw(X, Y);
        }

        DrawOrbAtSlot(Position01Id, 1);
        DrawOrbAtSlot(Position02Id, 2);
        DrawOrbAtSlot(Position03Id, 3);
        DrawOrbAtSlot(Position04Id, 4);
        
        if (IsCompleted || IsActive)
        {
            DrawScores();

            if (IsActive) 
            {
                NextButton.Draw(X + 101, Y);
            }
        }
    }

    public void DrawOrbAtSlot(int orbId, int slotId)
    {
        int xOffset = 29, yOffset = 24;
        int yPosition = (int)round(Y + (slotId - 1) * 80.5);
        switch (orbId) {
            case 1 :
                Images.Orb01Image.Draw(X + xOffset, yPosition + yOffset);
            break;	

            case 2 :
                Images.Orb02Image.Draw(X + xOffset, yPosition + yOffset);
            break;	

            case 3 :
                Images.Orb03Image.Draw(X + xOffset, yPosition + yOffset);
            break;	

            case 4 :
                Images.Orb04Image.Draw(X + xOffset, yPosition + yOffset);
            break;	

            case 5 :
                Images.Orb05Image.Draw(X + xOffset, yPosition + yOffset);
            break;	

            case 6 :
                Images.Orb06Image.Draw(X + xOffset, yPosition + yOffset);
            break;	
        }
    }

    public void DrawScores()
    {
        ColouredScoreIndicator.Draw(X, Y);
        WhiteScoreIndicator.Draw(X, Y + 437);
    }

    public boolean IsOverColouredScore()
    {
        return ColouredScoreIndicator.IsOver(X, Y);
    }

    public boolean IsOverWhiteScore()
    {
        return WhiteScoreIndicator.IsOver(X, Y + 437);
    }

    public boolean IsOverNextButton()
    {
        return NextButton.IsOver(X + 101, Y);
    }
}

public class ScoreIndicatorButton
{
    public ScaledImage ImageNone, Image1, Image2, Image3, Image4;
    public int Score = 0;

    public ScoreIndicatorButton(
        float scale,
        String img1,
        String img2,
        String img3,
        String img4,
        String img5
    )
    {
        ImageNone = new ScaledImage(img1, scale);
        Image1    = new ScaledImage(img2, scale);
        Image2    = new ScaledImage(img3, scale);
        Image3    = new ScaledImage(img4, scale);
        Image4    = new ScaledImage(img5, scale);
    }

    public void Draw(int x, int y)
    {
        int xOffset = -3, yOffset = -98;
        switch (Score)
        {
            case 0:
                ImageNone.Draw(x + xOffset, y + yOffset);
                break;
            case 1:
                Image1.Draw(x + xOffset, y + yOffset);
                break;
            case 2:
                Image2.Draw(x + xOffset, y + yOffset);
                break;
            case 3:
                Image3.Draw(x + xOffset, y + yOffset);
                break;
            case 4:
                Image4.Draw(x + xOffset, y + yOffset);
                break;
        }
    }

    public boolean IsOver(int x, int y)
    {
        int xOffset = -3, yOffset = -98;
        switch (Score)
        {
            case 0:
                return ImageNone.IsOver(x + xOffset, y + yOffset);
            case 1:
                return Image1.IsOver(x + xOffset, y + yOffset);
            case 2:
                return Image2.IsOver(x + xOffset, y + yOffset);
            case 3:
                return Image3.IsOver(x + xOffset, y + yOffset);
            case 4:
                return Image4.IsOver(x + xOffset, y + yOffset);
        }

        return false;
    }
}

public class SimpleImageButton
{
    public int X, Y;
    public ScaledImage Image1;

    public SimpleImageButton(
        float scale,
        String img
    )
    {
        Image1 = new ScaledImage(img, scale);
    }

    public SimpleImageButton(
        float scale,
        int x, int y,
        String img
    )
    {
        X = x;
        Y = y;
        Image1 = new ScaledImage(img, scale);
    }

    public void Draw()
    {
        Draw(X, Y);
    }

    public void Draw(int x, int y)
    {
        int xOffset = -3, yOffset = -95;
        Image1.Draw(x + xOffset, y + yOffset);
    }

    public boolean IsOver()
    {
        return IsOver(X, Y);
    }

    public boolean IsOver(int x, int y)
    {
        int xOffset = -3, yOffset = -95;
        return Image1.IsOver(x + xOffset, y + yOffset);
    }
}

public class DeckManager
{
    public DeckObject[] DeckObjects;

    DeckManager(float scale, ImageLibrary images, int x, int y, int pitch)
    {
        DeckObjects = new DeckObject[9];
        for (var i = 0; i < 9; i++)
        {
            DeckObjects[i] = new DeckObject(
                scale,
                images,
                i,
                x + (i * pitch),
                y
            );
        }
    }

    public void Draw()
    {
        for (var i = 0; i < 9; i++)
        {
            DeckObjects[i].Draw();
        }
    }
}

public class Score
{
    public int NumberOfRightColourAndPosition;
    public int NumberOfRightColourAndWrongPosition;

    Score()
    {

    }

    Score(int numberOfColouredPegs, int numberOfWhitePegs)
    {
        NumberOfRightColourAndPosition = numberOfColouredPegs;
        NumberOfRightColourAndWrongPosition = numberOfWhitePegs;
    }

    public boolean Equals(Score other)
    {
        return (NumberOfRightColourAndPosition == other.NumberOfRightColourAndPosition) 
            && (NumberOfRightColourAndWrongPosition == other.NumberOfRightColourAndWrongPosition);

    }
}

public class DeckData
{
    public int[] Data;

    DeckData(int lengthOfCode)
    {
        Data = new int[lengthOfCode];
    }

    DeckData(int value1, int value2, int value3, int value4)
    {
        Data = new int[4];

        Data[0] = value1;
        Data[1] = value2;
        Data[2] = value3;
        Data[3] = value4;
    }

    public int GetLength()
    {
        return Data.length;
    }

    public int Get(int index)
    {
        return Data[index];
    }

    public void Set(int index, int value)
    {
        Data[index] = value;
    }

    public boolean Equals(DeckData other)
    {
        if (Data.length != other.Data.length)
        {
            return false;
        }

        for (int i=0; i<Data.length; i++)
        {
            if (Data[i] != other.Data[i]) 
                return false;
        }

        return true;
    }
}

public class GameMaster
{
    public int NumberOfColours = 6;
    public int LengthOfCode = 4;
    public boolean Won = false;
    public int Turn = 1;

    public DeckData Code;
    public DeckData CurrentGuess;
    public ArrayList<DeckData> NextGuesses;
    public ArrayList<DeckData> Combinations;
    public ArrayList<DeckData> CandidateSolutions;
    public Score ResponseScore;

    GameMaster()
    {
        Turn = 1;
        Won = false;

        Code = new DeckData(LengthOfCode);

        ResponseScore = new Score();
        Combinations = new ArrayList<DeckData>();
        CandidateSolutions = new ArrayList<DeckData>();
        NextGuesses = new ArrayList<DeckData>();

        CurrentGuess = new DeckData( 1, 1, 2, 2 );
        CreateSet();

        for (int i=0; i<Combinations.size(); i++)
        {
            CandidateSolutions.add(
                Combinations.get(i)
            );
        }
    }

    public boolean RunOnce(Score score)
    {
        if (Won)
        {
            return false;
        }

        RemoveCode(Combinations, CurrentGuess);
        RemoveCode(CandidateSolutions, CurrentGuess);

        if (score.NumberOfRightColourAndPosition == 4)
        {
            Won = true;
            return false;
        }

        PruneCodes(CandidateSolutions, CurrentGuess, score);
        NextGuesses = MinMax();
        CurrentGuess = GetNextGuess(NextGuesses);

        Turn += 1;
        return true;
    }

    private DeckData GetNextGuess(ArrayList<DeckData> nextGuesses)
    {
        var nextGuess = new DeckData(LengthOfCode);

        for (int i = 0; i < nextGuesses.size(); ++i)
        {
            for (int j = 0; j < CandidateSolutions.size(); j++)
            {
                if (CandidateSolutions.get(j).Equals(nextGuesses.get(i)))
                    return nextGuesses.get(i);
            }
        }

        for (int i = 0; i < nextGuesses.size(); ++i)
        {
            for (int j = 0; j < Combinations.size(); j++)
            {
                if (Combinations.get(j) == nextGuesses.get(i))
                    return nextGuesses.get(i);
            }
        }

        return nextGuess;
    }

    private ArrayList<DeckData> MinMax()
    {
        var scoreCount = new HashMap<Score, Integer>();
        var score = new HashMap<DeckData, Integer>();
        var nextGuesses = new ArrayList<DeckData>();
        int max, min;

        for (int i = 0; i < Combinations.size(); ++i)
        {
            for (int j = 0; j < CandidateSolutions.size(); ++j)
            {
                var pegScore = CheckCode(Combinations.get(i), CandidateSolutions.get(j));

                if (scoreCount.containsKey(pegScore))
                {
                    scoreCount.put(pegScore, scoreCount.get(pegScore) + 1);
                }
                else
                {
                    scoreCount.put(pegScore, 1);
                }
            }

            max = GetMaxScore(scoreCount);
            score.put(Combinations.get(i), max);
            scoreCount.clear();
        }

        min = GetMinScore(score);

        for (var element : score.entrySet())
        {
            if (element.getValue() == min)
            {
                nextGuesses.add(element.getKey());
            }
        }

        return nextGuesses;
    }

    private int GetMaxScore(HashMap<Score, Integer> inputMap)
    {
        int max = 0;
        for (var element : inputMap.entrySet())
        {
            if (element.getValue() > max)
            {
                max = element.getValue();
            }
        }

        return max;
    }

    private int GetMinScore(HashMap<DeckData, Integer> inputMap)
    {
        var min = Integer.MAX_VALUE;
        for (var element : inputMap.entrySet())
        {
            if (element.getValue() < min)
            {
                min = element.getValue();
            }
        }

        return min;
    }

    private void PruneCodes(ArrayList<DeckData> set, DeckData currentCode, Score currentResponse)
    {
        for (int index = set.size() - 1; index >= 0; index--)
        {
            if (!CheckCode(currentCode, set.get(index)).Equals(currentResponse))
                set.remove(index);
        }
    }

    private Score CheckCode(DeckData guess, DeckData code)
    {
        int ignoreFlags = 0;
        Score score = new Score();

        for (int i = 0; i < LengthOfCode; i++)
        {
            var letter = guess.Get(i);

            for (int j = 0; j < code.GetLength(); j++)
            {
                if (letter == code.Get(j) && ((ignoreFlags >> j) & 0x1) != 0x1)
                {
                    ignoreFlags |= (1 << j);
                    score.NumberOfRightColourAndWrongPosition += 1;
                    break;
                }
            }

            switch (i)
            {
                case 0:
                    if (letter == code.Get(0))
                    {
                        score.NumberOfRightColourAndPosition += 1;
                        score.NumberOfRightColourAndWrongPosition -= 1;
                    }
                    break;
                case 1:
                    if (letter == code.Get(1))
                    {
                        score.NumberOfRightColourAndPosition += 1;
                        score.NumberOfRightColourAndWrongPosition -= 1;
                    }
                    break;
                case 2:
                    if (letter == code.Get(2))
                    {
                        score.NumberOfRightColourAndPosition += 1;
                        score.NumberOfRightColourAndWrongPosition -= 1;
                    }
                    break;
                case 3:
                    if (letter == code.Get(3))
                    {
                        score.NumberOfRightColourAndPosition += 1;
                        score.NumberOfRightColourAndWrongPosition -= 1;
                    }
                    break;
                default:
                    break;
            }
        }

        return score;
    }

    private void CreateSet()
    {
        var current = new DeckData(LengthOfCode);
        var elements = new int[NumberOfColours];

        for (int i = 0; i < NumberOfColours; i++)
        {
            elements[i] = i + 1;
        }

        CombinationRecursive(LengthOfCode, 0, current, elements);
    }

    private void RemoveCode(ArrayList<DeckData> set, DeckData currentCode)
    {
        for (int index = set.size() - 1; index >= 0; index--)
        {
            var item = set.get(index);
            if (
                item.Get(0) == currentCode.Get(0)
                && item.Get(1) == currentCode.Get(1)
                && item.Get(2) == currentCode.Get(2)
                && item.Get(3) == currentCode.Get(3)
            )
            {
                set.remove(index);
                break;
            }
        }
    }

    private void CombinationRecursive(
        int combinationLength,
        int position,
        DeckData current,
        int[] elements
    )
    {
        if (position >= combinationLength)
        {
            Combinations.add(
                new DeckData
                (
                    current.Get(0), current.Get(1),
                    current.Get(2), current.Get(3)
                )
            );

            return;
        }

        for (int j = 0; j < elements.length; ++j)
        {
            current.Set(position, elements[j]);
            CombinationRecursive(combinationLength, position + 1, current, elements);
        }
    }
}
