package com.opentext.installer.actions;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Properties;

import com.coi.tools.os.win.NativeLibException;
import com.coi.tools.os.win.RegDataContainer;
import com.izforge.izpack.adaptator.IXMLElement;
import com.izforge.izpack.installer.AutomatedInstallData;
import com.izforge.izpack.installer.PanelAction;
import com.izforge.izpack.installer.PanelActionConfiguration;
import com.izforge.izpack.util.AbstractUIHandler;
import com.izforge.izpack.util.Debug;
import com.izforge.izpack.util.os.RegistryHandler;
import com.izforge.izpack.util.os.Win_RegistryHandler;

/**
 * @author Dirk Raeder <draeder@opentext.com>
 * 
 */
public class RegistryWriterAction implements PanelAction {

  private String configurationFileName = "";

  private enum ActionModeEnum {
    append, prepend, overwrite, NOVALUE;

    protected static ActionModeEnum parse(String value) {
      try {
        return ActionModeEnum.valueOf(value.toLowerCase());
      } catch (Exception e) {
        return NOVALUE;
      }
    }
  }

  /**
   * 
   */
  public RegistryWriterAction() {
    super();
  }

  /*
   * (non-Javadoc)
   * 
   * @see
   * com.izforge.izpack.installer.PanelAction#executeAction(com.izforge.izpack
   * .installer.AutomatedInstallData, com.izforge.izpack.util.AbstractUIHandler)
   */
  @Override
  public void executeAction(AutomatedInstallData adata, AbstractUIHandler handler) {
    Debug.trace("RegistryWriterAction: Executing.");

    if (!RegistryActionsHelper.validate(this.configurationFileName, "RegistryWriterAction")) {
      return;
    }

    try {

      Properties properties = adata.getVariables();
      RegistryHandler rh = new Win_RegistryHandler();
      IXMLElement configuration = null;

      if (rh == null) {
        Debug.trace("RegistryWriterAction: Could not get RegistryHandler. Aborting.");
        return;
      }

      try {
        configuration = RegistryActionsHelper.loadConfiguration(this.configurationFileName);
      } catch (Throwable exception) {
        Debug.trace("RegistryWriterAction: Resource " + this.configurationFileName + " not defined. Aborting.");
        return;
      }

      if (rh.getDefaultHandler() != null) {
        rh = rh.getDefaultHandler();
      }

      rh.verify(adata);
      int oldRoot = rh.getRoot();

      for (IXMLElement action : configuration.getChildrenNamed(Constants.REGISTRY_ACTION_CONFIGURATION_ELEMENT)) {
        execute(action, properties, rh);
      }
      rh.setRoot(oldRoot);

      Debug.trace("RegistryWriterAction: Finished.");
    } catch (Exception e) {
      Debug.trace(e);
    }

  }

  /*
   * (non-Javadoc)
   * 
   * @see
   * com.izforge.izpack.installer.PanelAction#initialize(com.izforge.izpack.
   * installer.PanelActionConfiguration)
   */
  @Override
  public void initialize(PanelActionConfiguration configuration) {
    Debug.trace("RegistryWriterAction: Initializing.");
    if (configuration == null) {
      Debug.trace("RegistryWriterAction: Initialization failed.");
    } else {
      this.configurationFileName = configuration.getProperty(Constants.REGISTRY_RESOURCE_NAME, null).trim();
      Debug.trace(String.format("RegistryWriterAction: Initialization completed: Using resource %1$s",
          this.configurationFileName));
    }
  }

  private void execute(IXMLElement action, Properties properties, RegistryHandler rh) {
    String root = RegistryActionsHelper.getConfigurationValue(action, Constants.REGISTRY_ROOT, properties);
    String key = RegistryActionsHelper.getConfigurationValue(action, Constants.REGISTRY_KEY, properties);
    String name = RegistryActionsHelper.getConfigurationValue(action, Constants.REGISTRY_NAME, properties);
    String value = RegistryActionsHelper.getConfigurationValue(action, Constants.WRITER_VALUE, properties);
    ActionModeEnum mode = ActionModeEnum.parse(RegistryActionsHelper.getConfigurationValue(action,
        Constants.WRITER_MODE, properties));
    boolean createIfNew = Boolean.parseBoolean(RegistryActionsHelper.getConfigurationValue(action,
        Constants.WRITER_CREATE_IF_NEW, properties));

    Debug.trace(String.format("RegistryWriterAction: Accessing system registry. %1$s\\%2$s\\%3$s", root, key, name));
    String currentValue = null;

    try {
      rh.setRoot(RegistryHandler.ROOT_KEY_MAP.get(root));

//      for ( String o : RegistryHandler.ROOT_KEY_MAP.keySet()) {
//    	  System.out.println("ROOOT: "+o);
//      }
      
//      int i = RegistryHandler.ROOT_KEY_MAP.get(root);
//      System.out.println("INDEX: "+i);
//      
//      System.out.println(rh.getRoot());
//      
//      String[] tmp = rh.getValueNames("Environment");
//      for (String t : tmp ) {
//    	  System.out.println("TTTTTTTT: "+t);
//      }
      RegDataContainer rdc = rh.getValue(key, name, null);
      if (rdc == null) {
        if (createIfNew) {
          Debug.trace("RegistryWriterAction: Registry entry not found. Creating it.");
          currentValue = value;
        } else {
        	Debug.trace("RegistryWriterAction: Registry entry not found. Aborting.");
          return;
        }
      } else {
        currentValue = rdc.getStringData();
        Debug.trace("RegistryWriterAction: Registry entry found. Current value: " + currentValue);

        if ( currentValue != null && !"".equals(currentValue) && value != null && !"".equals(value)) {
        	if ( currentValue.toLowerCase().contains(value.toLowerCase()) ) {
        		Debug.trace("RegistryWriterAction: Registry key already contains value. Aborting.");
        		return;
        	}
        }
        
        switch (mode) {
        case append:
          currentValue = currentValue + value;
          break;
        case prepend:
          currentValue = value + currentValue;
          break;

        case overwrite:
          currentValue = value;
          break;
        }
      }

      Debug.trace("RegistryWriterAction: Setting value to " + currentValue);
      rh.setValue(key, name, currentValue);

    } catch (NativeLibException nle) {
//    	try {
//            FileWriter fstream=new FileWriter("C:\\Users\\Markus\\exception.txt");
//            BufferedWriter out=new BufferedWriter(fstream);
//            out.write(nle.toString());
//            out.write("\nKEY: "+key);
//            out.write("\nNAME: "+name);
//            out.write("\nVALUE: "+currentValue);
//            StringWriter sw = new StringWriter();
//            PrintWriter pw = new PrintWriter(sw);
//            nle.printStackTrace(pw);
//            out.write("\nSTACKTRACE:\n"+sw.toString()); // stack trace as a string
//            out.close();
//        	} catch (Exception e2) {
//        		
//        	}
      Debug.trace("RegistryWriterAction, Accessing system registry failed: "+nle.getLocalizedLibMessage());
      Debug.trace(nle);
    } catch (Exception e) {
    	e.printStackTrace();
//    	try {
//        FileWriter fstream=new FileWriter("C:\\Users\\Markus\\exception.txt");
//        BufferedWriter out=new BufferedWriter(fstream);
//        out.write(e.toString());
//        out.close();
//    	} catch (Exception e2) {
//    		
//    	}
    }
  }
}