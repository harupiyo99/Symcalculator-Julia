# Juliaを用いた代数・解析計算用web電卓(開発中)
JuliaとGenieFrameworkを活用した、Webブラウザ上で動作する代数解析電卓です。
数式を入力すると、`Symbolics.jl` を用いた代数的計算を行い、結果をLaTeX形式で表示します。

## 目的
代数計算を、ブラウザ上で行いたいので作っています。

## 課題点
LaTeX記法で出力された結果を、レンダリングしてきれいな数式として表示することがまだできていません。

## 使用技術
- **Language**: Julia v1.10+
- **Framework**: GenieFramework.jl (Stipple, StippleUI)
- **Math Engine**: Symbolics.jl, Latexify.jl
- **Environment**: WSL2 (Ubuntu)
