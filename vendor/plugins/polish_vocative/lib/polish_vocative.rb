class String
  module PolishVocative
    RULES = {
      /a$/ => [
        [/świnia$/, 'świnio'],
        [/śka$/, 'śko'],
        [/sia$/, 'siu'],
        [/zia$/, 'ziu'],
        [/cia$/, 'ciu'],
        [/nia$/, 'niu'],
        [/aja$/, 'aju'],
        [/ola$/, 'olu'],
        [/a$/, 'o']
      ],
      /b$/ => [
        [/b$/, 'bie']
      ],
      /c$/ => [
        [/ojciec$/, 'ojcze'],
        [/starzec$/, 'starcze'],
        [/ciec$/, 'ćcu'],
        [/liec$/, 'łcu'],
        [/niec$/, 'ńcu'],
        [/siec$/, 'ścu'],
        [/ziec$/, 'źcu'],
        [/lec$/, 'lcu'],
        [/c$/, 'cu']
      ],
      /ć$/ => [
        [/gość$/, 'gościu'],
        [/ść$/, 'ściu'],
        [/ć$/, 'cio']
      ],
      /d$/ => [
        [/łąd$/, 'łędzie'],
        [/ód$/, 'odzie'],
        [/d$/, 'dzie']
      ],
      /f$/ => [
        [/f$/, 'fie']
      ],
      /g$/ => [
        [/bóg$/, 'boże'],
        [/g$/, 'gu']
      ],
      /h$/ => [
        [/ph$/, 'ph'],
        [/h$/, 'hu']
      ],
      /j$/ => [
        [/ój$/, 'oju'],
        [/j$/, 'ju']
      ],
      /k$/ => [
        [/człek$/, 'człeku'],
        [/ciek$/, 'ćku'],
        [/liek$/, 'łku'],
        [/niek$/, 'ńku'],
        [/siek$/, 'śku'],
        [/ziek$/, 'źku'],
        [/wiek$/, 'wieku'],
        [/ek$/, 'ku'],
        [/k$/, 'ku']
      ],
      /l$/ => [
        [/sól$/, 'solo'],
        [/mól$/, 'mole'],
        [/l$/, 'lu']
      ],
      /ł$/ => [
        [/zioł$/, 'źle'],
        [/ół$/, 'ole'],
        [/eł$/, 'le'],
        [/ł$/, 'le']
      ],
      /m$/ => [
        [/m$/, 'mie']
      ],
      /n$/ => [
        [/nikola$/, 'nikolo'],
        [/syn$/, 'synu'],
        [/n$/, 'nie']
      ],
      /ń$/ => [
        [/skroń$/, 'skronio'],
        [/dzień$/, 'dniu'],
        [/czeń$/, 'czniu'],
        [/ń$/, 'niu']
      ],
      /p$/ => [
        [/p$/, 'pie']
      ],
      /r$/ => [
        [/per$/, 'prze'],
        [/ór$/, 'orze'],
        [/r$/, 'rze']
      ],
      /s$/ => [
        [/ies$/, 'sie'],
        [/s$/, 'sie']
      ],
      /ś$/ => [
        [/gęś$/, 'gęsio'],
        [/ś$/, 'siu']
      ],
      /t$/ => [
        [/st$/, 'ście'],
        [/t$/, 'cie']
      ],
      /w$/ => [
        [/konew$/, 'konwio'],
        [/sław$/, 'sławie'],
        [/lew$/, 'lwie'],
        [/łw$/, 'łwiu'],
        [/ów$/, 'owie'],
        [/w$/, 'wie']
      ],
      /x$/ => [
        [/x$/, 'ksie']
      ],
      /z$/ => [
        [/ksiądz$/, 'księże'],
        [/dz$/, 'dzu'],
        [/cz$/, 'czu'],
        [/rz$/, 'rzu'],
        [/sz$/, 'szu'],
        [/óz$/, 'ozie'],
        [/z$/, 'zie']
      ],
      /ż$/ => [
        [/ąż$/, 'ężu'],
        [/ż$/, 'żu']
      ]
    }
  end
  
  def vocative
    _first, _last = self.split ' ', 2
    _first.downcase!
    
    PolishVocative::RULES.each do |key, branch|
      if _first[key]
        branch.each do |src, dst|
          break if _first.sub! src, dst
        end
        break
      end
    end
      
    _first.capitalize!
    [_first, _last].compact.join ' '
  end
end