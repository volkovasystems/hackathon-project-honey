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
void setup( ){
  size( 1200, 800 );
  frame.setTitle( "Honey" );
  addMode( PROJECT_SELECTION );
  addMode( PROJECT_SELECTION_IDLE );
  addMode( PROJECT_NAME_EMPTY );
}

void draw( ){
  background( 255 );
  drawOnProjectSelectionMode( );
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
    createProjectTitleIcon( );
    createProjectTitle( );
    createProjectInputPane( );
    if( checkMode( PROJECT_NAME_EMPTY ) ){
      createProjectInputPrompt( );
    }
    if( checkMode( TYPING_PROJECT_NAME ) ){
      
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

void createProjectTitleIcon( ){
  pushMatrix( );
  
  
  
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
  fill( 123 );
  textFont( projectInputPromptFont );
  int x = baseLeftDistance - 5 + baseLeftDistance + 70 + 10 + 50;
  int y = baseTopDistance + 20;
  text( "Start typing your project name.", x, y );
  
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
