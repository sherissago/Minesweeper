

import de.bezier.guido.*;
public final static int NUM_ROWS =20; 
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to declare and initialize buttons goes here
    buttons= new MSButton[NUM_ROWS][NUM_COLS];
    for(int row = 0; row < buttons.length;row++)
    {
      for(int col = 0; col < buttons.length;col++)
      {
        buttons[row][col] = new MSButton(row,col);
      }
    }
    
    setBombs();
}
public void setBombs()
{
  while (bombs.size() < NUM_ROWS)
  {
  int bRow = (int)(Math.random()*NUM_ROWS);
  int bCol = (int)(Math.random()*NUM_COLS);
  if(!bombs.contains(buttons[bRow][bCol]))
  {
    bombs.add(buttons[bRow][bCol]);
  }
  }
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
    else
    displayLosingMessage();
}
public boolean isWon()
{
    for(int r = 0; r < NUM_ROWS; r++)
    {
      for(int c = 0; c <NUM_COLS; c++)
      {
        if(bombs.contains(buttons[r][c]) && buttons[r][c].isClicked())
        {
          return false;
        }
      }
    }
     return true;
}
public void displayLosingMessage()
{
    {
      rect(160,160,80,30);
      text("You lose!",160,160);
    }
}
public void displayWinningMessage()
{
    {
      rect(160,160,80,30);
      text("You win!",160,160);
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
   
        if(mouseButton == LEFT)
        {
          if(clicked == false)
          {
            clicked = true;
            if (keyPressed == true)
            {
              marked = !marked;
            }
            else if(bombs.contains(this))
            {
              displayLosingMessage();
            }
            else if (countBombs(r,c) > 0)
            {
              label+=countBombs(r,c);
            }
            else for(int i = -1; i <=1; i++)
            {
              for(int j =-1; j<=1; j++)
              {
                if(isValid(r+i, c+j) && !buttons[r+i][c+j].isClicked())
                {
                  buttons[r+i][c+j].mousePressed();
                }
              }
            }
          }
        }
  
          
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int row, int col)
    {
        if(row >=0 && r< NUM_ROWS && col >=0 && c < NUM_COLS)
        {
        return true;
        }
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int i = -1; i <=1; i++)
        {
          for(int j = -1; j <=1; j++)
          {
            if(isValid(row+i,col+j) && bombs.contains(buttons[row+i][col+j]))
            {
              numBombs++;
            }
          }
        }
        return numBombs;
    }
}
