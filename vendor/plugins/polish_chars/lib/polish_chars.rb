class String
  module PolishChars
    TO_ASCII = {
      'Ą' => 'A',
      'Ć' => 'C',
      'Ę' => 'E',
      'Ł' => 'L',
      'Ń' => 'N',
      'Ó' => 'O',
      'Ś' => 'S',
      'Ż' => 'Z',
      'Ź' => 'Z',
      'ą' => 'a',
      'ć' => 'c',
      'ę' => 'e',
      'ł' => 'l',
      'ń' => 'n',
      'ó' => 'o',
      'ś' => 's',
      'ż' => 'z',
      'ź' => 'z',
    }
  end

  def to_ascii
    res = String.new

    i = 0
    while i < self.length
      next_i = i + 1;
      if next_i < self.length
        if c = PolishChars::TO_ASCII[self[i].chr + self[next_i].chr]
          res << c
          i = next_i + 1
        else
          res << self[i]
          i = next_i
        end
      else
        res << self[i]
        i = next_i
      end
    end

    res
  end
end