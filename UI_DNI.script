class PokemonTrainerCard_Scene
  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def pbStartScene
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    background = pbResolveBitmap(sprintf("Graphics/Pictures/Trainer Card/bg_f"))
    if $Trainer.female? && background
      addBackgroundPlane(@sprites,"bg","Trainer Card/bg_f",@viewport)
    else
      addBackgroundPlane(@sprites,"bg","Trainer Card/bg",@viewport)
    end
    cardexists = pbResolveBitmap(sprintf("Graphics/Pictures/Trainer Card/card_f"))
    @sprites["card"] = IconSprite.new(0,0,@viewport)
    if $Trainer.female? && cardexists
      @sprites["card"].setBitmap("Graphics/Pictures/Trainer Card/card_f")
    else
      @sprites["card"].setBitmap("Graphics/Pictures/Trainer Card/card")
    end
    @sprites["overlay"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    @sprites["trainer"] = IconSprite.new(345,175,@viewport)
    @sprites["trainer"].setBitmap(GameData::TrainerType.player_front_sprite_filename($Trainer.trainer_type))
    @sprites["trainer"].x -= (@sprites["trainer"].bitmap.width-128)/2
    @sprites["trainer"].y -= (@sprites["trainer"].bitmap.height-128)
    @sprites["trainer"].z = 2
    pbDrawTrainerCardFront
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

    def pbDrawTrainerCardFront
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    baseColor   = Color.new(0,0,0)
    shadowColor = Color.new(160,160,160)
    totalsec = Graphics.frame_count / Graphics.frame_rate
    hour = totalsec / 60 / 60
    min = totalsec / 60 % 60
    time = (hour>0) ? _INTL("{1}h {2}m",hour,min) : _INTL("{1}m",min)
    $PokemonGlobal.startTime = pbGetTimeNow if !$PokemonGlobal.startTime
    starttime = _INTL("{1} {2}, {3}",
       pbGetAbbrevMonthName($PokemonGlobal.startTime.mon),
       $PokemonGlobal.startTime.day,
       $PokemonGlobal.startTime.year)
    textPositions = [
       [_INTL("Nombre"),170,70,0,baseColor,shadowColor],
       [$Trainer.name,170,90,0,baseColor,shadowColor],
       [_INTL("DNI "),31,311,0,baseColor,shadowColor],
       [sprintf("%05d",$Trainer.public_ID($Trainer.id)),140,311,1,baseColor,shadowColor],
       [_INTL("Dinero"),170,120,0,baseColor,shadowColor],
       [_INTL("{1} €",$Trainer.money.to_s_formatted),170,140,0,baseColor,shadowColor],
       [_INTL("Wikipedia"),170,170,0,baseColor,shadowColor],
       [sprintf("%d/%d",$Trainer.pokedex.owned_count,$Trainer.pokedex.seen_count),170,190,0,baseColor,shadowColor],
       [_INTL("Tiempo"),170,220,0,baseColor,shadowColor],
       [time,170,240,0,baseColor,shadowColor],
       [_INTL("Comienzo"),170,270,0,baseColor,shadowColor],
       [starttime,170,290,0,baseColor,shadowColor]
    ]
    pbDrawTextPositions(overlay,textPositions)
    x = 72
    region = pbGetCurrentRegion(0) # Get the current region
    imagePositions = []
    for i in 0...8
      if $Trainer.badges[i+region*8]
        imagePositions.push(["Graphics/Pictures/Trainer Card/icon_badges",x,310,i*32,region*32,32,32])
      end
      x += 48
    end
    pbDrawImagePositions(overlay,imagePositions)
  end

  def pbTrainerCard
    pbSEPlay("GUI trainer card open")
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        break
      end
    end
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

class PokemonTrainerCardScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene
    @scene.pbTrainerCard
    @scene.pbEndScene
  end
end
