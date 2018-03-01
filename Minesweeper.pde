import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to declare and initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int z = 0; z < NUM_ROWS; z++)  
    {
        for (int x = 0; x < NUM_COLS; x++)
        {
            buttons[z][x] = new MSButton(z, x);
        }    
    }       
        setBombs();
}
public void setBombs()
{
    while (bombs.size() < ((int)(Math.random()*50))+25)
    {
        int row = (int)(Math.random()*NUM_ROWS);
        int col = (int)(Math.random()*NUM_COLS);
        if (!bombs.contains(buttons[row][col]))
        {
            bombs.add(buttons[row][col]);
            //System.out.print(bombs.size());
        }
    }
}

public void draw ()
{
    background(0);
    if(isWon() == true)
        displayWinningMessage();
    //System.out.println(isWon());
}
public boolean isWon()
{
    int bombWin = 0;
    for (int i = 0; i < bombs.size(); i++)  
    {
        if (bombs.get(i).isMarked())
            bombWin++;
    }
    if (bombWin == bombs.size())
        return true;
    return false;
}
public void displayLosingMessage()
{
    for (int r = 0; r < NUM_ROWS; r++)  
    {
        for (int c = 0; c < NUM_COLS; c++)
        {
            if (bombs.contains(buttons[r][c]))
                buttons[r][c].setLabel("B");
        }    
    }     
    String loseDeath = new String("Game Over!");
    for (int i = 0; i < loseDeath.length(); i++)
    {
        buttons[NUM_ROWS/2][(NUM_COLS/2) - 5 + i].setLabel(loseDeath.substring(i, i+1));
    }
}
public void displayWinningMessage()
{
    String winSurvive = new String("You Win!");
    for (int i = 0; i < winSurvive.length(); i++)
    {
        buttons[NUM_ROWS/2][(NUM_COLS/2) - 5 + i].setLabel(winSurvive.substring(i, i+1));
    }
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if (mouseButton == RIGHT) 
        {
            marked = !marked;
            if (marked == false)
                clicked = false;
        }
        //your code here
        else if (bombs.contains(this) && !isMarked())
            displayLosingMessage();
        else if (countBombs(r, c) > 0)
            label = ""+ countBombs(r, c);
        else
        {
            if(isValid(r+1, c) && buttons[r+1][c].isClicked() == false)
                buttons[r+1][c].mousePressed();
            if(isValid(r-1, c) && buttons[r-1][c].isClicked() == false)
                buttons[r-1][c].mousePressed();
            if(isValid(r, c+1) && buttons[r][c+1].isClicked() == false)
                buttons[r][c+1].mousePressed();
            if(isValid(r, c-1) && buttons[r][c-1].isClicked() == false)
                buttons[r][c-1].mousePressed();
        }

    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if(clicked && bombs.contains(this)) 
            fill(255,0,0);
        else if(clicked)
            fill(200);
        else 
            fill(100);

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
            return true;
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for (int rw = -1; rw <= 1; rw++)
        {
            for (int cl = -1; cl <= 1; cl++)
            {
                if (isValid(row + rw, col + cl) && bombs.contains(buttons[row + rw][col + cl]))
                    numBombs++;
            }
        }
        return numBombs;
    }
}



