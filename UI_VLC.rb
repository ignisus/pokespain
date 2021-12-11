class PokemonJukebox_Scene
  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def pbStartScene(commands)
    @commands = commands
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    @sprites["background"] = IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap("Graphics/Pictures/Pokegear/vlcbg")
    @sprites["header"] = Window_UnformattedTextPokemon.newWithSize(
       _INTL("VLC"),2,-18,128,64,@viewport)
    @sprites["header"].baseColor   = Color.new(248,248,248)
    @sprites["header"].shadowColor = Color.new(0,0,0)
    @sprites["header"].windowskin  = nil
    @sprites["commands"] = Window_CommandPokemon.newWithSize(@commands,
       94,92,324,224,@viewport)
    @sprites["commands"].baseColor   = Color.new(0,0,0)
    @sprites["commands"].shadowColor = Color.new(168,168,168)
    @sprites["commands"].windowskin = nil
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def pbScene
    ret = -1
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::B)
        break
      elsif Input.trigger?(Input::C)
        ret = @sprites["commands"].index
        break
      end
    end
    return ret
  end

  def pbSetCommands(newcommands,newindex)
    @sprites["commands"].commands = (!newcommands) ? @commands : newcommands
    @sprites["commands"].index    = newindex
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

class PokemonJukeboxScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    commands = []
    cmdFito     = -1
    cmdNavajita = -1
    cmdMelendi  = -1
    cmdEstopa   = -1
    cmdDani     = -1
    cmdCustom   = -1
    commands[cmdFito = commands.length]     = _INTL("Fito y Fitipaldis - Soldadito Marinero")
    commands[cmdNavajita = commands.length] = _INTL("Navajita Platea - Noches de Bohemia")
    commands[cmdMelendi = commands.length]  = _INTL("Melendi - La Promesa")
    commands[cmdEstopa = commands.length]   = _INTL("Estopa - Como Camaron")
    commands[cmdDani = commands.length]     = _INTL("Dani Martin - Cero")
    commands[cmdCustom = commands.length]   = _INTL("Otros...")
    @scene.pbStartScene(commands)
    loop do
      cmd = @scene.pbScene
      if cmd<0
        pbPlayCloseMenuSE
        break
      elsif cmdFito>=0 && cmd==cmdFito
        pbPlayDecisionSE
        pbBGMPlay("Fito y Fitipaldis - Soldadito Marinero", 100, 100)
        $PokemonMap.whiteFluteUsed = true if $PokemonMap
        $PokemonMap.blackFluteUsed = false if $PokemonMap
      elsif cmdNavajita>=0 && cmd==cmdNavajita
        pbPlayDecisionSE
        pbBGMPlay("Navajita Platea - Noches de Bohemia", 100, 100)
        $PokemonMap.blackFluteUsed = true if $PokemonMap
        $PokemonMap.whiteFluteUsed = false if $PokemonMap
      elsif cmdMelendi>=0 && cmd==cmdMelendi
        pbPlayDecisionSE
        pbBGMPlay("Melendi - La Promesa", 100, 100)
        $PokemonMap.blackFluteUsed = true if $PokemonMap
        $PokemonMap.whiteFluteUsed = false if $PokemonMap
      elsif cmdEstopa>=0 && cmd==cmdEstopa
        pbPlayDecisionSE
        pbBGMPlay("Estopa - Como Camaron", 100, 100)
        $PokemonMap.whiteFluteUsed = false if $PokemonMap
        $PokemonMap.blackFluteUsed = false if $PokemonMap
      elsif cmdDani>=0 && cmd==cmdDani
        pbPlayDecisionSE
        pbBGMPlay("Dani Martin - Cero", 100, 100)
        $PokemonMap.whiteFluteUsed = true if $PokemonMap
        $PokemonMap.blackFluteUsed = false if $PokemonMap
      elsif cmdCustom>=0 && cmd==cmdCustom
        pbPlayDecisionSE
        files = [_INTL("(Default)")]
        Dir.chdir("Audio/BGM/") {
          Dir.glob("*.mp3") { |f| files.push(f) }
          Dir.glob("*.MP3") { |f| files.push(f) }
          Dir.glob("*.ogg") { |f| files.push(f) }
          Dir.glob("*.OGG") { |f| files.push(f) }
          Dir.glob("*.wav") { |f| files.push(f) }
          Dir.glob("*.WAV") { |f| files.push(f) }
          Dir.glob("*.mid") { |f| files.push(f) }
          Dir.glob("*.MID") { |f| files.push(f) }
          Dir.glob("*.midi") { |f| files.push(f) }
          Dir.glob("*.MIDI") { |f| files.push(f) }
        }
        @scene.pbSetCommands(files,0)
        loop do
          cmd2 = @scene.pbScene
          if cmd2<0
            pbPlayCancelSE
            break
          elsif cmd2==0
            pbPlayDecisionSE
            $game_system.setDefaultBGM(nil)
            $PokemonMap.whiteFluteUsed = false if $PokemonMap
            $PokemonMap.blackFluteUsed = false if $PokemonMap
          else
            pbPlayDecisionSE
            $game_system.setDefaultBGM(files[cmd2])
            $PokemonMap.whiteFluteUsed = false if $PokemonMap
            $PokemonMap.blackFluteUsed = false if $PokemonMap
          end
        end
        @scene.pbSetCommands(nil,cmdCustom)
      else   # Exit
        pbPlayCloseMenuSE
        break
      end
    end
    @scene.pbEndScene
  end
end
