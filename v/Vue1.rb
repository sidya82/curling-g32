# Classe creation de la vue de sélection de fichier ou dossier
class Vue1
  # Creation de la vue
  def initialize(ctrl, title, type)
    @ctrl = ctrl
    #fenenetre generale
    @window = Gtk::Window.new
    @window.set_title(title)
    
    #declaration des differents widgets
    vb = Gtk::VBox.new(true, 6)
    bot = Gtk::HBox.new(false, 6)
    
    #creation label pour la saisie
    lab = Gtk::Label.new('Chemin :')
    bot.pack_start(lab, false, true, 6)
    
    #creation champ de saisie
    #@nom = Gtk::Entry.new
    if (type == 1)
      @nom = Gtk::FileChooserButton.new("choisir un fichier", Gtk::FileChooser::ACTION_OPEN)
    else
      @nom = Gtk::FileChooserButton.new("choisir un dossier ", Gtk::FileChooser::ACTION_SELECT_FOLDER)
    end
    @nom.set_current_folder("../fichier")
    bot.pack_start(@nom, true, true)
    
    #creation bouton de validation
    @b = Gtk::Button.new('OK')
    bot.pack_start(@b)
    vb.pack_start(bot)
    ##############################
    
    @window.add(vb)
    
    # Abbonement fenetre au Listener
    self.listenerBouton
    self.listenerDestroy
  end
  
  def getWindow #:nodoc:#
      return @window
  end
  
  def getEntry #:nodoc:#
    return @chaine
  end
  
  # Listener fermeture fenetre 
  def listenerDestroy 
    @window.signal_connect('destroy') {
      @ctrl.destructionFen
    }
  end

  #Listener appuie bouton validation
  def listenerBouton 
    @chaine = " "
    @b.signal_connect('clicked'){ 
    @chaine = @nom.filename
    if (@chaine =="") #gestion saisie vide
      m = Gtk::MessageDialog.new(Gtk::Window.new, Gtk::Dialog::DESTROY_WITH_PARENT,
			    Gtk::MessageDialog::ERROR,
			    Gtk::MessageDialog::BUTTONS_CLOSE,
			    "Erreur : Veuillez saisir un fichier ou dossier !")
	     m.run
	     m.destroy  
    else
      if(File.directory?(@chaine)) #si c'est un dossier utilisation du controleur adéquat
          @ctrl.recupUrlsDoss(@chaine)
      else
      	if(File.exist?(@chaine))  #si c'est un fichier existant utilisation du controleur adéquat
      	  @ctrl.recupUrls(@chaine)
      	else #gestion saisie invalide
      	  d = Gtk::MessageDialog.new(Gtk::Window.new, Gtk::Dialog::DESTROY_WITH_PARENT,
      			      Gtk::MessageDialog::ERROR,
      			      Gtk::MessageDialog::BUTTONS_CLOSE,
      			      "Erreur :  Fichier ou dossier inexistant !")
      	  d.run
      	  d.destroy  
	       end
      end
    end
    }
  end
end
