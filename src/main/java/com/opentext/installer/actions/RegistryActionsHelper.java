package com.opentext.installer.actions;

import java.io.InputStream;
import java.util.Properties;

import com.izforge.izpack.adaptator.IXMLElement;
import com.izforge.izpack.adaptator.IXMLParser;
import com.izforge.izpack.adaptator.impl.XMLParser;
import com.izforge.izpack.installer.ResourceManager;
import com.izforge.izpack.util.Debug;
import com.izforge.izpack.util.OsVersion;
import com.izforge.izpack.util.VariableSubstitutor;

public final class RegistryActionsHelper {
  
  /**
   * Validates whether the operating system is MS Windows and all required
   * properties have been set.
   * 
   * @return true, if the action is able to execute. false else.
   */
  protected static boolean validate(String configurationFileName, String actionName) {
    boolean result = true;

    if (result && (!OsVersion.IS_WINDOWS)) {
      Debug.trace(actionName + " can only be executed on MS Windows. Aborting.");
      result = false;
    }

    if (result && (configurationFileName == null || "".equals(configurationFileName.trim()))) {
      Debug.trace(actionName + ": Configuration file not defined. Aborting.");
      result = false;
    }

    return result;
  }

  /**
   * Loads the resource defined in this.configurationFileName and parses it into
   * an IXMLElement.
   * 
   * @return
   * @throws Throwable
   */
  protected static IXMLElement loadConfiguration(String configurationFileName) throws Throwable {
    InputStream inXML = ResourceManager.getInstance().getInputStream(configurationFileName);
    IXMLParser parser = new XMLParser();
    IXMLElement result = parser.parse(inXML);
    return result;
  }
  
  /**
   * @param configuration
   * @param name
   * @param properties
   * @return
   */
  protected static String getConfigurationValue(IXMLElement configuration, String name, Properties properties) {
    String result = configuration.getFirstChildNamed(name).getAttribute("value");
    result = doVariableSubstitution(properties, result);
    return result;
  }

  /**
   * Calls IzPack's variable substitutor to process any variable in input.
   * 
   * @param properties
   * @param input
   * @return
   */
  private static String doVariableSubstitution(Properties properties, String input) {
    VariableSubstitutor vs = new VariableSubstitutor(properties);
    String output = vs.substitute(input, null);
    return output;
  }

}
