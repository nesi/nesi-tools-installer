package com.opentext.installer.actions;

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
 */
public class RegistryReaderAction implements PanelAction {

  private final String empty = "";
  private String configurationFileName = null;
  private AutomatedInstallData adata = null;
  private String root = null;
  private String keypath = null;
  private String name = null;
  private String target = null;
  private String append = null;
  private String defaultValue = null;
  private Properties properties = null;
  private int registryHandlerOldRoot;
  private RegistryHandler registryHandler;

  public RegistryReaderAction() {
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
    Debug.trace("RegistryReaderAction: Starting.");
    
    if (!RegistryActionsHelper.validate(this.configurationFileName, "RegistryReaderAction")) {
      // log information already written in validate();
      return;
    }
    this.properties = adata.getVariables();
    this.adata = adata;

    try {
      loadAndExecuteActions();
    } catch (Exception e) {
    	e.printStackTrace();
      Debug.trace(e);
    }
    
    Debug.trace("REGISTRY WRITTEN");
  }

  private void loadAndExecuteActions() throws Exception {
    Debug.trace("RegistryReaderAction: Preparing registry handler.");
    prepareRegistryHandler();

    Debug.trace("RegistryReaderAction: Loading configuration.");
    IXMLElement configuration = loadConfiguration();

    for (IXMLElement action : configuration.getChildrenNamed(Constants.REGISTRY_ACTION_CONFIGURATION_ELEMENT)) {
      initializeAsCurrentAction(action);
      executeCurrentAction();
    }

    disposeOfRegistryHandler();
    
    Debug.trace("RegistryReaderAction: Finished.");
  }

  private IXMLElement loadConfiguration() throws Exception {
    IXMLElement configuration = null;

    try {
      configuration = RegistryActionsHelper.loadConfiguration(this.configurationFileName);
    } catch (Throwable exception) {
      throw new Exception("RegistryReaderAction: Resource " + this.configurationFileName + " not defined. Aborting.", exception);
    }
    return configuration;
  }

  private void disposeOfRegistryHandler() throws NativeLibException {
    this.registryHandler.setRoot(this.registryHandlerOldRoot);
    this.registryHandler = null;
  }

  private void prepareRegistryHandler() throws Exception {
    this.registryHandler = new Win_RegistryHandler();
    
    if (this.registryHandler == null) {
      throw new Exception("RegistryReaderAction: Could not get RegistryHandler. Aborting.");
    }
    
    if (this.registryHandler.getDefaultHandler() != null) {
      this.registryHandler = this.registryHandler.getDefaultHandler();
    }
    this.registryHandler.verify(this.adata);
    this.registryHandlerOldRoot = this.registryHandler.getRoot();
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
    Debug.trace("RegistryReaderAction: Initializing.");
    if (configuration == null) {
      Debug.trace("RegistryReaderAction: Initialization failed.");
    } else {
      this.configurationFileName = configuration.getProperty(Constants.REGISTRY_RESOURCE_NAME, null).trim();
      Debug.trace(String.format("RegistryReaderAction: Initialization completed: Using resource %1$s",
          this.configurationFileName));
    }
  }

  private void executeCurrentAction() {
    Debug.trace(String.format("RegistryReaderAction: Executing. Reading %1$S\\%2$s\\%3$s", this.root, this.keypath, this.name));
    try {
      this.registryHandler.setRoot(RegistryHandler.ROOT_KEY_MAP.get(this.root));

      RegDataContainer rdc = this.registryHandler.getValue(this.keypath, this.name, null);
      if (rdc == null) {
        setTargetToDefaultValue();
      } else {
        setTargetToRegistryValue(rdc);
      }
    } catch (Exception e) {
      Debug.trace(e);
      setTargetToDefaultValue();
    }
  }

  private void initializeAsCurrentAction(IXMLElement action) {
    this.root = RegistryActionsHelper.getConfigurationValue(action, Constants.REGISTRY_ROOT, this.properties);
    this.keypath = RegistryActionsHelper.getConfigurationValue(action, Constants.REGISTRY_KEY, this.properties);
    this.name = RegistryActionsHelper.getConfigurationValue(action, Constants.REGISTRY_NAME, this.properties);
    this.target = RegistryActionsHelper.getConfigurationValue(action, Constants.READER_SET_VARIABLE, this.properties);
    this.append = RegistryActionsHelper.getConfigurationValue(action, Constants.READER_APPEND, this.properties);
    this.defaultValue = RegistryActionsHelper.getConfigurationValue(action, Constants.READER_DEFAULT_VALUE, this.properties);
  }
  
  private void setTargetToDefaultValue() {
    if (this.defaultValue == null) {
      Debug.trace("RegistryReaderAction: Registry entry not found; no default set. Skipping.");
    } else {
      Debug.trace("RegistryReaderAction: Registry entry not found. Using default value.");
      this.adata.setVariable(this.target, this.defaultValue);
    }
  }
  
  private void setTargetToRegistryValue(RegDataContainer rdc) {
    String registryValue = rdc.getStringData();
    if (this.append != null && !this.empty.equals(this.append.trim())) {
      registryValue += this.append;
    }
    Debug.trace(String.format("RegistryReaderAction: Setting variable %1$s to %2$s", this.target, registryValue));
    
    this.adata.setVariable(this.target, registryValue);
  }
  
}
