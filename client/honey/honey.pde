import java.util.LinkedList;

int baseTopDistance = 40;
int baseLeftDistance = 40;

/*
================================================================================================================
*/
final String PROJECT_SELECTION = "project-selection";
final String TYPING_PROJECT_NAME = "typing-project-name";
final String PROJECT_NAME_EMPTY = "project-name-empty";
final String PROJECT_NAME_ENTERED = "project-name-entered";
final String PROJECT_SELECTION_IDLE = "project-selection-idle";
final String PROJECT_FOUND = "project-found";
/*
================================================================================================================
*/

/*
================================================================================================================
*/
final LinkedList<String> appMode = new LinkedList<String>( );
void addMode( String mode ){
  if( !checkMode( mode ) ){
    appMode.push( mode );
  }
}

void removeMode( String mode ){
  appMode.remove( mode ); 
}

boolean checkMode( String mode ){
  return appMode.contains( mode );
}
/*
================================================================================================================
*/

/*
================================================================================================================
*/
PImage searchIcon;
PImage projectIcon;
PImage closeIcon;
PImage addIcon;
PImage doneIcon;
PImage taskIcon;
void loadImages( ){
  searchIcon = loadImage( "search.png" );
  projectIcon = loadImage( "project.png" );
  closeIcon = loadImage( "close.png" );
  addIcon = loadImage( "add.png" );
  doneIcon = loadImage( "done.png" );
  taskIcon = loadImage( "task.png" );
}
/*
================================================================================================================
*/

/*
================================================================================================================
*/
void setup( ){
  size( 1200, 800 );
  frame.setTitle( "Honey" );
  addMode( PROJECT_SELECTION );
  addMode( PROJECT_SELECTION_IDLE );
  addMode( PROJECT_NAME_EMPTY );
  
  loadImages( );
}

void draw( ){
  background( 255 );
  drawOnProjectSelectionMode( );
  drawOnProjectFound( );
}
/*
================================================================================================================
*/

/*
================================================================================================================
*/
void keyPressed( ){
  keyPressedOnProjectSelectionMode( );
}
/*
================================================================================================================
*/

/*
================================================================================================================
*/
void drawOnProjectFound( ){
  if( checkMode( PROJECT_FOUND ) ){
    
  }
}
/*
================================================================================================================
*/


/*
================================================================================================================
*/
String projectName = "";
void keyPressedOnProjectSelectionMode( ){
  if( checkMode( PROJECT_SELECTION ) ){
    if( keyCode == BACKSPACE ){
      if( !checkMode( PROJECT_NAME_EMPTY ) ){
        projectName = projectName.substring( 0, projectName.length( ) - 1 );
      }
    }else if( keyCode == ENTER ){
      removeMode( TYPING_PROJECT_NAME );
      addMode( PROJECT_NAME_ENTERED );
    }else{
      addMode( TYPING_PROJECT_NAME );
      projectName += key;
    }
    if( projectName.length( ) == 0 ){
      addMode( PROJECT_NAME_EMPTY );
    }else{
      removeMode( PROJECT_NAME_EMPTY );
    }
  }
}

void drawOnProjectSelectionMode( ){
  createHeaderSection( );
  if( checkMode( PROJECT_SELECTION ) ){
    //println( "Current mode is project selection." );
    createProjectTitlePane( );
    createSearchIcon( );
    createProjectTitle( );
    createProjectInputPane( );
    if( checkMode( PROJECT_NAME_EMPTY ) ){
      createProjectInputPrompt( );
    }
    if( checkMode( TYPING_PROJECT_NAME ) ){
      renderProjectName( );
    }
  }
}

void createProjectTitlePane( ){
  pushMatrix( );
  
  stroke( 0 );
  fill( 255 );
  int x = baseLeftDistance - 5;
  int y = baseTopDistance - 10;
  int w = baseLeftDistance + 70 + 50;
  int h = 45;
  rect( x, y, w, h ); 
  
  popMatrix( );
}

void createSearchIcon( ){
  pushMatrix( );
  
  image( searchIcon, 0, 0 );
  
  popMatrix( );
}

void createProjectTitle( ){
  pushMatrix( );
  
  PFont projectTitleFont = createFont( "Verdana", 25, true );
  fill( 0 );
  textFont( projectTitleFont );
  int x = baseLeftDistance + 50;
  int y = baseTopDistance + 20;
  text( "Project:", x, y );
  
  popMatrix( );
}

void createProjectInputPane( ){
  pushMatrix( );
  
  stroke( 0 );
  fill( 255 );
  int x = baseLeftDistance - 5 + baseLeftDistance + 70 + 50;
  int y = baseTopDistance - 10;
  int w = width - x + 15 - 50;
  int h = 45;
  rect( x, y, w, h );
  
  popMatrix( );
}

void createProjectInputPrompt( ){
  pushMatrix( );
  
  PFont projectInputPromptFont = createFont( "Verdana", 20, true );
  fill( 123 );
  textFont( projectInputPromptFont );
  int x = baseLeftDistance - 5 + baseLeftDistance + 70 + 10 + 50;
  int y = baseTopDistance + 20;
  text( "Start typing your project name.", x, y );
  
  popMatrix( );
}

void renderProjectName( ){
  pushMatrix( );
  
  PFont projectInputPromptFont = createFont( "Verdana", 20, true );
  fill( 0 );
  textFont( projectInputPromptFont );
  
  int projectNameWidth = (int)textWidth( projectName );
  int projectInputPaneLeftDistance = baseLeftDistance - 5 + baseLeftDistance + 70 + 50;  
  int boundaryWidth = width - projectInputPaneLeftDistance + 15 - 50 - 20;
  
  int x = baseLeftDistance - 5 + baseLeftDistance + 70 + 10 + 50;
  int y = baseTopDistance + 20;  
  if( projectNameWidth < boundaryWidth ){
    text( projectName, x, y );
  }else{
    //text( projectName, x, y );
  }
  
  
  popMatrix( );
}

/*
================================================================================================================
*/
void createHeaderSection( ){
  pushMatrix( );
  
  stroke( 0, 255, 26 );
  fill( 139, 255, 61 );
  rect( 0, 0, width, 100 );
  
  popMatrix( );
}
/*
================================================================================================================
*/
