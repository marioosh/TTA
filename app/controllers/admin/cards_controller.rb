class Admin::CardsController < Admin::DefaultController
  def index
    @cards = Card.all(:order => 'age, type, name', :include => :card_images)
  end

  def export
    @cards = Card.all(:order => 'age, type, name')
  end

  def edit
    @card = Card.find(params[:id])
    @types = [
      ['', nil],
      ['Cywilna - Lider', 'Civil::Leader'],
      ['Cywilna - Akcja', 'Civil::Action'],
      ['Cywilna - Cud świata', 'Civil::Wonder'],

      ['Cywilna - Technologia - Specjalna', 'Civil::Technology::Special'],
      ['Cywilna - Technologia - Ustrój', 'Civil::Technology::Government'],

      ['Cywilna - Technologia - Kopalnia', 'Civil::Technology::MineOrFarm::Mine'],
      ['Cywilna - Technologia - Farma', 'Civil::Technology::MineOrFarm::Farm'],

      ['Cywilna - Jednostki - Piechota', 'Civil::Technology::Unit::Infrantry'],
      ['Cywilna - Jednostki - Artyleria', 'Civil::Technology::Unit::Artillery'],
      ['Cywilna - Jednostki - Kawaleria', 'Civil::Technology::Unit::Cavalry'],
      ['Cywilna - Jednostki - Lotnictwo', 'Civil::Technology::Unit::AirForce'],

      ['Cywilna - Budynki - Świątynia', 'Civil::Technology::Urban::Temple'],
      ['Cywilna - Budynki - Laboratorium', 'Civil::Technology::Urban::Laboratory'],
      ['Cywilna - Budynki - Biblioteka', 'Civil::Technology::Urban::Library'],
      ['Cywilna - Budynki - Arena', 'Civil::Technology::Urban::Arena'],
      ['Cywilna - Budynki - Teatr', 'Civil::Technology::Urban::Theatre'],

      ['Militarna - Agresja', 'Military::Aggression'],
      ['Militarna - Bonus', 'Military::Bonus'],
      ['Militarna - Terytorium', 'Military::Territory'],
      ['Militarna - Pakt', 'Military::Pact'],
      ['Militarna - Taktyka', 'Military::Tactics'],
      ['Militarna - Wydarzenie', 'Military::Event'],
      ['Militarna - Wojna', 'Military::War']
    ]

    if @card
      @cards = Card.all(:order => 'age, type, name')
      @cards.each_index do |i|
        if @cards[i].id == @card.id
          @next = @cards[i+1]
          @prev = @cards[i-1]
          break
        end
      end

      if request.post? && params[:card]
        @card.type = params[:card].delete(:type)
        @card.update_attributes(params[:card])
        if @card.valid?
          @card.image = "public/files/source/#{@card.image.filename}" if @card.image && File.exists?("public/files/source/#{@card.image.filename}")
          @card.save

          if @card.next && @next
            redirect_to :id => @next.id
          else
            redirect_to :action => :index
          end
        end
      else
        @card.next = true
      end
    end
  end

  def upload
    @images = []
    @files = Dir.glob("public/files/source/*.png")
    @files.each do |file|
      img = CardImage.find(:first, :conditions => ['file = ?', File.basename(file)])
      @images << file.sub('public', '') if img.nil?
    end
  end

  def define
    @file = "#{params[:id]}.png"
    @card = Card.find(:first, :conditions => ['card_images.file = ?', @file], :include => :card_images)
    if @card
      redirect_to :action => :edit, :id => @card.id
    else
      @card = Card.new
      if request.post? && params[:card]
        @card.update_attributes(params[:card])
        if @card.valid?
          @card.save
          @card.image = "public/files/source/#{@file}"

          @files = Dir.glob("public/files/source/*.png")
          @files.each do |file|
            img = CardImage.find(:first, :conditions => ['file = ?', File.basename(file)])
            if img.nil?
              redirect_to :id => File.basename(file).sub('.png', '')
              return
            end
          end

          redirect_to :action => :upload
        end
      end
    end
  end
end
