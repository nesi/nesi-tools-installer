package nz.org.nesi.installer.version;

import com.izforge.izpack.installer.AutomatedInstallData;
import com.izforge.izpack.installer.PanelAction;
import com.izforge.izpack.installer.PanelActionConfiguration;
import com.izforge.izpack.util.AbstractUIHandler;
import com.izforge.izpack.util.Debug;
import com.opentext.installer.actions.Constants;

public class WriteVersionAction implements PanelAction {
	
	private String version = null;
	private String path = null;

	@Override
	public void executeAction(AutomatedInstallData adata,
			AbstractUIHandler handler) {
		
		System.out.println("HAHAHAHAH: "+version);
		System.out.println("HAHAHAHAH: "+path);

	}

	@Override
	public void initialize(PanelActionConfiguration configuration) {

	    Debug.trace("RegistryReaderAction: Initializing.");
	    if (configuration == null) {
	      Debug.trace("RegistryReaderAction: Initialization failed.");
	    } else {
	      this.version = configuration.getProperty("InstallerVersion", null).trim();
	      this.path = configuration.getProperty("InstallPath", null).trim();
	      Debug.trace(String.format("RegistryReaderAction: Initialization completed: Using version %1$s",
	          this.version));
	    }
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

}
