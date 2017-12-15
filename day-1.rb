require "rspec"

def captcha(input, offset: 1)
  input.cycle.each_cons(offset + 1).take(input.length).select { |a| a.first == a.last }.map(&:first).sum
end

def recaptcha(input, offset: 1)
  [*0...input.length].sum { |i| input[i] == input[(i + offset) % input.length] ? input[i] : 0 }
end

describe "captcha" do
  [
    [[1,1,2,2], 3],
    [[1,1,1,1], 4],
    [[1,2,3,4], 0],
    [[9,1,2,1,2,1,2,9], 9]
  ].each do |input, sum|
    specify "#{input.inspect} produces sum of #{sum}" do
      expect(captcha(input)).to eq sum
      expect(recaptcha(input)).to eq sum
    end
  end

  context "with half offset" do
    [
      [[1,2,1,2], 6],
      [[1,2,2,1], 0],
      [[1,2,3,4,2,5], 4],
      [[1,2,3,1,2,3], 12],
      [[1,2,1,3,1,4,1,5], 4]
    ].each do |input, sum|
      specify "#{input.inspect} produces sum of #{sum}" do
        offset = input.length / 2
        expect(captcha(input, offset)).to eq sum
        expect(recaptcha(input, offset)).to eq sum
      end
    end
  end
end

# Part 1
input = <<-INPUT.strip.chars.map(&:to_i)
29917128875332952564321392569634257121244516819997569284938677239676779378822158323549832814412597817651244117851771257438674567254146559419528411463781241159837576747416543451994579655175322397355255587935456185669334559882554936642122347526466965746273596321419312386992922582836979771421518356285534285825212798113159911272923448284681544657616654285632235958355867722479252256292311384799669645293812691169936746744856227797779513997329663235176153745581296191298956836998758194274865327383988992499115472925731787228592624911829221985925935268785757854569131538763133427434848767475989173579655375125972435359317237712667658828722623837448758528395981635746922144957695238318954845799697142491972626942976788997427135797297649149849739186827185775786254552866371729489943881272817466129271912247236569141713377483469323737384967871876982476485658337183881519295728697121462266226452265259877781881868585356333494916519693683238733823362353424927852348119426673294798416314637799636344448941782774113142925315947664869341363354235389597893211532745789957591898692253157726576488811769461354938575527273474399545366389515353657644736458182565245181653996192644851687269744491856672563885457872883368415631469696994757636288575816146927747179133188841148212825453859269643736199836818121559198563122442483528316837885842696283932779475955796132242682934853291737434482287486978566652161245555856779844813283979453489221189332412315117573259531352875384444264457373153263878999332444178577127433891164266387721116357278222665798584824336957648454426665495982221179382794158366894875864761266695773155813823291684611617853255857774422185987921219618596814446229556938354417164971795294741898631698578989231245376826359179266783767935932788845143542293569863998773276365886375624694329228686284863341465994571635379257258559894197638117333711626435669415976255967412994139131385751822134927578932521461677534945328228131973291962134523589491173343648964449149716696761218423314765168285342711137126239639867897341514131244859826663281981251614843274762372382114258543828157464392
INPUT

puts recaptcha(input, offset: 1)

# Part 2

puts recaptcha(input, offset: input.length / 2)
