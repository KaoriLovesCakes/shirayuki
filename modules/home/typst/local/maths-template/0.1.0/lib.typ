// #import "@preview/down:0.1.0": *
#import "@preview/physica:0.9.5": *
#import "@preview/rubber-article:0.5.0": *
#import "@preview/suiji:0.4.0": *
#import "@preview/thmbox:0.2.0": *
#import "@preview/unify:0.7.1": *



#let get-thmbox(variant) = {
  let color-and-fill = (
    if variant in ("Axiom", "Definition") {
      (red, red.transparentize(90%))
    } else if variant in "Conjecture" {
      (orange, orange.transparentize(90%))
    } else if variant in ("Corollary", "Lemma", "Proposition", "Theorem") {
      (green, green.transparentize(90%))
    } else if variant in ("Example", "Exercise", "Note") {
      (blue, blue.transparentize(90%))
    } else {
      (gray, gray.transparentize(100%))
    }
  )

  thmbox.with(
    color: color-and-fill.at(0),
    fill: color-and-fill.at(1),
    variant: variant,
    sans: false,
  )
}

#let axiom = get-thmbox("Axiom")
#let conjecture = get-thmbox("Conjecture")
#let corollary = get-thmbox("Corollary")
#let definition = get-thmbox("Definition")
#let example = get-thmbox("Example")
#let exercise = get-thmbox("Exercise")
#let lemma = get-thmbox("Lemma")
#let note = get-thmbox("Note")
#let proposition = get-thmbox("Proposition")
#let theorem = get-thmbox("Theorem")
#let proof(..args, body) = get-thmbox("Proof").with(
  numbering: none,
  variant: if args.pos().len() == 1 [Proof of #args.at(0)] else [Proof],
)(body + qed())
#let solution(..args, body) = get-thmbox("Solution").with(
  numbering: none,
  variant: if args.pos().len() == 1 [Solution of #args.at(0)] else [Solution],
)(body)

#let bf(input) = $upright(bold(input))$

#let numbered(body) = {
  set math.equation(numbering: "(1)")
  body
  set math.equation(numbering: none)
}

#let template(..args, body) = {
  show: article.with(
    lang: "en",
    text-font: ("New Computer Modern", "Source Han Serif"),
  )

  show: thmbox-init()
  show figure.where(kind: "thmbox"): set block(breakable: true)

  maketitle(..args)

  body
}
