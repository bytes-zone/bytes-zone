+++
title = "Kitchen Sink"
template = "post.html"
+++

This is a kitchen sink page for me to make sure all the styled elements on this site look OK in one go.
It's really not meant to be used by anyone but me!

**TODO:** figure out how to make this not show up in the sitemap.

<!-- more -->

---

## heading level two
### heading level three
#### heading level four
##### heading level five
###### heading level six

## this is a really long second level header, intended to break onto several lines to see how well the underline background works

This is a paragraph with some *emphasized text*, **strongly emphasized text**, <del>struck-through text</del>, and `inline code`.
Oh, and [here's a link to the homepage](/).

Now for an unordered list:

- unordered
- list
- items

Great, and an ordered one:

1. ordered
1. list
2. items

Cool.
How about some inspiration?

>> You miss 100% of the shots you don't take
>>
>> — Wayne Gretzky
>
> — Michael Scott

{{ youtube(id="LNCC6ZYI3SI", title="You would never guess this is what a rhino sounds like.") }}

## Elm Code Sample

```elm
catDecoder : Decoder Cat
catDecoder =
    Decode.succeed Cat
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "color" Decode.string
```

## Ruby Code Sample

```ruby
class Cat << T::Struct
  prop :name, String
  prop :color, String
end
```

## Haskell Code Sample

```haskell
data Cat =
  Cat
    { name :: Text,
      color :: Text
    }
```

## Nix Code Sample

```nix
{ pkgs ? import <nixpkgs> {}, ... }:
pkgs.stdenv.mkDerivation {
  name = "cats";
  src = ./.;
  
  buildPhase = "true";
  installPhase = ''
    mkdir $out/share/cats
    cp -r cats/ $out/share/cats
  '';
}
```

## Alloy Code Sample

```alloy
sig Foo {
  bar: one Bar,
  baz: some Baz,
  quux: lone Quux,
}

check SomeName {
  all f: Foo | one b: Bar | f.bar = b
} for 4 but 1 Foo
```

## Generic (Overflowing) Code Sample

```
EVERY MORNING I WAKE UP AND OPEN PALM SLAM A VHS INTO THE SLOT.
ITS CHRONICLES OF RIDDICK AND RIGHT THEN AND THERE I START DOING THE MOVES ALONGSIDE WITH THE MAIN CHARACTER, RIDDICK.
I DO EVERY MOVE AND I DO EVERY MOVE HARD.
MAKIN WHOOSHING SOUNDS WHEN I SLAM DOWN SOME NECRO BASTARDS OR EVEN WHEN I MESS UP TECHNIQUE.
NOT MANY CAN SAY THEY ESCAPED THE GALAXY’S MOST DANGEROUS PRISON.
I CAN.
I SAY IT AND I SAY IT OUTLOUD EVERYDAY TO PEOPLE IN MY COLLEGE CLASS AND ALL THEY DO IS PROVE PEOPLE IN COLLEGE CLASS CAN STILL BE IMMATURE JERKS.
AND IVE LEARNED ALL THE LINES AND IVE LEARNED HOW TO MAKE MYSELF AND MY APARTMENT LESS LONELY BY SHOUTING EM ALL.
2 HOURS INCLUDING WIND DOWN EVERY MORNING.
THEN I LIFT
```
