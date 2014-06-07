import java.util.LinkedList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

int baseTopDistance = 40;
int baseLeftDistance = 40;

/*
================================================================================================================
*/
final String USER_AGENT = "Mozilla/5.0";

final String PROJECT_SELECTION = "project-selection";
final String TYPING_PROJECT_NAME = "typing-project-name";
final String PROJECT_NAME_EMPTY = "project-name-empty";
final String PROJECT_NAME_ENTERED = "project-name-entered";
final String PROJECT_SELECTION_IDLE = "project-selection-idle";

final String PROJECT_FOUND = "project-found";
final String PROJECT_CLOSE = "project-close";

final String TYPING_COMMAND = "typing-command";
final String COMMAND_EMPTY = "command-empty";
final String COMMAND_ENTERED = "command-entered";

final String FEATURE_ADDED = "feature-added";
final String FEATURE_TITLE_ENTERED = "feature-title-entered";
final String FEATURE_DESCRIPTION_ENTERED = "feature-description-entered";
final String FEATURE_CHECKLIST_NOT_EMPTY = "feature-checklist-not-empty";

final String START_REQUEST = "start-request";
final String END_REQUEST = "end-request";

final String CREATE_FEATURE_BRANCH = "create-feature-branch";
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
String sendRequest( String path, String request ){
  removeMode( END_REQUEST );
  addMode( START_REQUEST );
  try{
    String url = "http://127.0.0.1:8080/" + path + "?" + request;
   
    URL urlObject = new URL( url );
    HttpURLConnection connection = ( HttpURLConnection )urlObject.openConnection( );
   
    // optional default is GET
    connection.setRequestMethod( "GET" );
   
    //add request header
    connection.setRequestProperty( "User-Agent", USER_AGENT );
   
    int responseCode = connection.getResponseCode( );
    
    BufferedReader inputBuffer = new BufferedReader( new InputStreamReader( connection.getInputStream( ) ) );
    String inputLine;
    StringBuffer response = new StringBuffer( );
   
    while( ( inputLine = inputBuffer.readLine( ) ) != null ){
      response.append( inputLine );
    }
    inputBuffer.close( );
    return response.toString( );
  }catch( Exception exception ){
    println( exception.getMessage( ) );
    return "false";
  }finally{
    removeMode( START_REQUEST );
    addMode( END_REQUEST );
  }
}

boolean checkIfRepositoryExists( ){
  try{
    String encodedProjectNamespace = URLEncoder.encode( projectName, "UTF-8" );
    return sendRequest( "repository/check/exists", "projectNamespace=" + encodedProjectNamespace ).equals( "true" );
  }catch( Exception exception ){
    println( exception.getMessage( ) );
    return false;
  }  
}

boolean createFeatureBranch( ){
  try{
    String encodedFeatureNamespace = URLEncoder.encode( currentFeature, "UTF-8" );
    String encodedProjectNamespace = URLEncoder.encode( projectName, "UTF-8" );
    return sendRequest( "feature/create/branch", "featureNamespace=" + encodedFeatureNamespace + "&projectNamespace=" + encodedProjectNamespace ).equals( "true" );
  }catch( Exception exception ){
    println( exception.getMessage( ) );
    return false;
  }
}

/*
================================================================================================================
*/

/*
================================================================================================================
*/
PImage searchIcon;
PImage projectIcon;
PImage taskIcon;
PImage featureIcon;
void loadImages( ){
  searchIcon = loadImage( "search.png" );
  projectIcon = loadImage( "project.png" );
  featureIcon = loadImage( "feature.png" );
  taskIcon = loadImage( "task.png" );
}
/*
================================================================================================================
*/

/*
================================================================================================================
*/
void setup( ){
  size( 800, 500 );
  frame.setTitle( "Honey" );
  addMode( PROJECT_SELECTION );
  addMode( PROJECT_SELECTION_IDLE );
  addMode( PROJECT_NAME_EMPTY );
  
  loadImages( );
}

void draw( ){
  background( 255 );
  createHeaderSection( );
  drawOnProjectSelectionMode( );
  drawOnProjectFound( );
  drawOnFeatureAdded( );
}
/*
================================================================================================================
*/

/*
================================================================================================================
*/
void keyPressed( ){
  keyPressedOnProjectSelectionMode( );
  keyPressedOnProjectFoundMode( );
}
/*
================================================================================================================
*/

/*
================================================================================================================
*/
void drawOnFeatureAdded( ){
  if( checkMode( FEATURE_ADDED ) ){
    createFeaturePane( );
    createFeatureIcon( );
    createFeatureTitle( );
    renderCurrentFeatureTitle( );
    createFeautureDescriptionTitle( );
    renderCurrentFeatureDescription( );
    //createFeatureChecklistTitle( );
    if( checkMode( CREATE_FEATURE_BRANCH ) ){
      removeMode( CREATE_FEATURE_BRANCH );
      if( createFeatureBranch( ) ){
        
      }
    }
  }
}

void createFeaturePane( ){
  pushMatrix( );
  
  stroke( 194, 194, 194 );
  fill( 224, 224, 224 );
  rect( 0, 101, width - 1, 200 );
  
  popMatrix( );
}

void createFeatureIcon( ){
  pushMatrix( );
  
  int x = 20;
  int y = 101 + 20; 
  stroke( 0 );
  image( featureIcon, x, y );
  //rect( x, y, 32, 32 );
  
  popMatrix( );
}

void createFeatureTitle( ){
  pushMatrix( );
  
  PFont featureTitleFont = createFont( "Verdana", 15, true );
  fill( 0 );
  textFont( featureTitleFont );
  int x = 20 + 32 + 10;
  int y = 101 + 43;
  text( "Feature:", x, y );
  
  popMatrix( );
}

void renderCurrentFeatureTitle( ){
  pushMatrix( );
  
  PFont featureFont = createFont( "Verdana", 25, true );
  fill( 0 );
  textFont( featureFont );
  int x = 20 + 32 + 10 + 70;
  int y = 101 + 45;
  text( currentFeature, x, y );
  
  popMatrix( );
}

void createFeautureDescriptionTitle( ){
  pushMatrix( );
  
  PFont featureDescriptionTitleFont = createFont( "Verdana", 15, true );
  fill( 0 );
  textFont( featureDescriptionTitleFont );
  int x = 20 + 5;
  int y = 101 + 40 + 45;
  text( "Description:", x, y );
  
  popMatrix( );
}

void renderCurrentFeatureDescription( ){
  pushMatrix( );
  
  PFont featureDescriptionFont = createFont( "Verdana", 25, true );
  fill( 0 );
  textFont( featureDescriptionFont );
  int x = 20 + 5 + 100;
  int y = 101 + 40 + 45 + 2;
  text( currentFeatureDescription, x, y );
  
  popMatrix( );
}

void createFeatureChecklistTitle( ){
  pushMatrix( );
  
  PFont featureChecklistTitleFont = createFont( "Verdana", 15, true );
  fill( 0 );
  textFont( featureChecklistTitleFont );
  int x = 20 + 5;
  int y = 101 + 40 + 45 + 45;
  text( "Checklist:", x, y );
  
  popMatrix( );
}

void renderCurrentFeatureChecklist( ){
}
/*
================================================================================================================
*/

/*
================================================================================================================
*/
String currentCommand = "";
void keyPressedOnProjectFoundMode( ){
  if( checkMode( PROJECT_FOUND ) ){
    if( keyCode == BACKSPACE ){
      if( !checkMode( COMMAND_EMPTY ) ){
        currentCommand = currentCommand.substring( 0, currentCommand.length( ) - 1 );
      }
    }else if( keyCode == ENTER ){
      removeMode( TYPING_COMMAND );
      addMode( COMMAND_ENTERED );
    }else{
      addMode( TYPING_COMMAND );
      currentCommand += key;
    }
    if( currentCommand.length( ) == 0 ){
      addMode( COMMAND_EMPTY );
    }else{
      removeMode( COMMAND_EMPTY );
    }
  }
}

void drawOnProjectFound( ){
  if( checkMode( PROJECT_FOUND ) ){
      createProjectIcon( );
      renderProjectNameAsTitle( );
      createCommandInputPane( );
      if( checkMode( COMMAND_EMPTY ) ){
        createCommandInputPrompt( );
      }else{
        renderCurrentCommand( );
      }
      if( checkMode( COMMAND_ENTERED ) ){
        removeMode( COMMAND_ENTERED );
        if( parse( ) ){
          addMode( COMMAND_EMPTY );
          currentCommand = "";
        }
      }
  }
}

void renderProjectNameAsTitle( ){
  pushMatrix( );
  
  PFont projectNameFont = createFont( "Verdana", 30, true );
  fill( 0 );
  textFont( projectNameFont );
  int x = baseLeftDistance + 40;
  int y = baseTopDistance + 23;
  text( projectName, x, y );
  
  popMatrix( );
}

void createProjectIcon( ){
  pushMatrix( );
  
  int x = baseLeftDistance;
  int y = baseTopDistance - 3; 
  stroke( 0 );
  image( projectIcon, x, y );
  //rect( x, y, 32, 32 );
  
  popMatrix( );
}

void createCommandInputPane( ){
  pushMatrix( );
  
  stroke( 0 );
  fill( 255 );
  int x = 0;
  int y = height - 35;
  int w = width - 1;
  int h = 35;
  rect( x, y, w, h );
  
  popMatrix( );
}

void createCommandInputPrompt( ){
  pushMatrix( );
  
  PFont commandInputPromptFont = createFont( "Consolas", 20, true );
  fill( 123 );
  textFont( commandInputPromptFont );
  int x = 5;
  int y = height - 10;
  text( "Start typing your commands.", x, y );
  
  popMatrix( );
}

String slicedCurrentCommand = "";
void renderCurrentCommand( ){
  pushMatrix( );
  
  PFont currentCommandFont = createFont( "Consolas", 20, true );
  fill( 0 );
  textFont( currentCommandFont );
  
  int currentCommandWidth = (int)textWidth( currentCommand );
  int boundaryWidth = width - 20;
  
  int x = 5;
  int y = height - 10;
  if( currentCommandWidth < boundaryWidth ){
    text( currentCommand, x, y );
    slicedCurrentCommand = currentCommand.substring( 0, currentCommand.length( ) );
  }else{
    text( slicedCurrentCommand, x, y );
  }
  
  popMatrix( );
}
/*
================================================================================================================
*/

/*
================================================================================================================
*/
//APP PARSER
String currentFeature = "";
String currentFeatureDescription = "";
LinkedList<String> currentFeatureChecklist = new LinkedList<String>( );
boolean parse( ){
   String addFeaturePattern = "^[Aa]dd\\s+[Ff]eature\\s+([-\\s\\w]+)";
   String setFeatureTitlePattern = "^[Ss]et\\s+[Ff]eature(?:-|\\s+)[Tt]itle\\s+([-\\s\\w]+)";
   String setFeatureDescriptionPattern = "^[Ss]et\\s+[Ff]eature(?:-|\\s+)[Dd]escription\\s+([-\\s\\w]+)";
   String addFeatureChecklistPattern = "^[Aa]dd\\s+[Ff]eature(?:-|\\s+)[Cc]hecklist\\s+([-\\s\\w]+)";
   
   if( currentCommand.matches( addFeaturePattern ) ){
     if( !checkMode( FEATURE_TITLE_ENTERED ) ){
       Matcher matcher = Pattern.compile( addFeaturePattern ).matcher( currentCommand );
       if( matcher.matches( ) ){
         currentFeature = matcher.group( 1 );
       }
       addMode( FEATURE_TITLE_ENTERED );
       addMode( FEATURE_ADDED );
       addMode( CREATE_FEATURE_BRANCH );
       return true;
     }else{
       //TODO: Prompt here.
     }     
   }
   
   if( currentCommand.matches( setFeatureTitlePattern ) ){
     if( checkMode( FEATURE_TITLE_ENTERED ) ){
       Matcher matcher = Pattern.compile( setFeatureTitlePattern ).matcher( currentCommand );
       if( matcher.matches( ) ){
         currentFeature = matcher.group( 1 );
       }
       return true;
     }else{
       //TODO: Prompt here.
     }
   }
   
   if( currentCommand.matches( setFeatureDescriptionPattern ) ){
     if( checkMode( FEATURE_TITLE_ENTERED ) ){
       Matcher matcher = Pattern.compile( setFeatureDescriptionPattern ).matcher( currentCommand );
       if( matcher.matches( ) ){
         currentFeatureDescription = matcher.group( 1 );
       }
       addMode( FEATURE_DESCRIPTION_ENTERED );
       return true;
     }else{
       //TODO: Prompt here.
     }
   }
   
   if( currentCommand.matches( addFeatureChecklistPattern ) ){
     if( checkMode( FEATURE_TITLE_ENTERED ) ){
       Matcher matcher = Pattern.compile( addFeatureChecklistPattern ).matcher( currentCommand );
       if( matcher.matches( ) ){
         currentFeatureChecklist.push( matcher.group( 1 ) );
       }
       addMode( FEATURE_CHECKLIST_NOT_EMPTY );
       return true;
     }else{
       //TODO: Prompt here.
     }
   }
   
   return false;
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
    
    if( checkMode( PROJECT_NAME_ENTERED ) ){
      //TODO: Check project from github if existing.
      removeMode( PROJECT_NAME_ENTERED );
      if( checkIfRepositoryExists( ) ){
        removeMode( PROJECT_SELECTION );
        removeMode( TYPING_PROJECT_NAME );
        removeMode( PROJECT_NAME_EMPTY );
        removeMode( PROJECT_SELECTION_IDLE );
  
        addMode( PROJECT_FOUND );
        addMode( COMMAND_EMPTY );
      }else{
        addMode( PROJECT_NAME_EMPTY );
        projectName = "";
      }
    }
  }
}

void createProjectTitlePane( ){
  pushMatrix( );
  
  stroke( 0 );
  fill( 255 );
  int x = baseLeftDistance - 5;
  int y = baseTopDistance - 10;
  int w = baseLeftDistance + 70 + 40;
  int h = 45;
  rect( x, y, w, h ); 
  
  popMatrix( );
}

void createSearchIcon( ){
  pushMatrix( );
  
  int x = baseLeftDistance;
  int y = baseTopDistance - 3; 
  stroke( 0 );
  image( searchIcon, x, y );
  //rect( x, y, 32, 32 );
  
  popMatrix( );
}

void createProjectTitle( ){
  pushMatrix( );
  
  PFont projectTitleFont = createFont( "Verdana", 25, true );
  fill( 0 );
  textFont( projectTitleFont );
  int x = baseLeftDistance + 40;
  int y = baseTopDistance + 20;
  text( "Project:", x, y );
  
  popMatrix( );
}

void createProjectInputPane( ){
  pushMatrix( );
  
  stroke( 0 );
  fill( 255 );
  int x = baseLeftDistance - 5 + baseLeftDistance + 70 + 40;
  int y = baseTopDistance - 10;
  int w = width - x + 15 - 40;
  int h = 45;
  rect( x, y, w, h );
  
  popMatrix( );
}

void createProjectInputPrompt( ){
  pushMatrix( );
  
  PFont projectInputPromptFont = createFont( "Verdana", 20, true );
  fill( 123 );
  textFont( projectInputPromptFont );
  int x = baseLeftDistance - 5 + baseLeftDistance + 70 + 10 + 40;
  int y = baseTopDistance + 20;
  text( "Start typing your project name.", x, y );
  
  popMatrix( );
}

String slicedProjectName = "";
void renderProjectName( ){
  pushMatrix( );
  
  PFont projectInputPromptFont = createFont( "Verdana", 20, true );
  fill( 0 );
  textFont( projectInputPromptFont );
  
  int projectNameWidth = (int)textWidth( projectName );
  int projectInputPaneLeftDistance = baseLeftDistance - 5 + baseLeftDistance + 70 + 40;  
  int boundaryWidth = width - projectInputPaneLeftDistance + 15 - 40 - 20;
  
  int x = baseLeftDistance - 5 + baseLeftDistance + 70 + 10 + 40;
  int y = baseTopDistance + 20;  
  if( projectNameWidth < boundaryWidth ){
    text( projectName, x, y );
    slicedProjectName = projectName.substring( 0, projectName.length( ) );
  }else{
    text( slicedProjectName, x, y );
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
  rect( 0, 0, width - 1, 100 );
  
  popMatrix( );
}
/*
================================================================================================================
*/
