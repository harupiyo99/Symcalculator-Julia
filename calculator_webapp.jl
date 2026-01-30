# Main空間へ変数xを直接登録することで、計算実行ボタンをいくら押しても反応しない状況を解決しました。
# これにより、とりあえず式を入力し、微分した式をLaTeX形式で出力するところまではいけました。

using GenieFramework
using Symbolics
using Latexify
@genietools

@app begin
    @in input_expr = "x^2 + sin(x)"
    @in compute = false   
    @out res_latex = "2x + \\cos(x)"

    # ボタンが押された（computeがtrueになった）とき動く
    @onbutton compute begin
        try
            # 1. 独立変数を明示的にMainに定義
            Main.eval(:(@variables x))
            
            # 2. 文字列を Julia の数式にパースする
            # Meta.parse で式にし、それを eval で評価する
            clean_input = strip(input_expr)
            parsed_expr = Base.eval(Main, Meta.parse(clean_input))

            # 3. 微分を実行
            der = expand_derivatives(Differential(Main.x)(parsed_expr))
            
            # 4. LaTeX文字列に変換
            res_latex = latexify(der).s
        catch e
            @show e
            # エラーの種類をブラウザに出して修正を助ける
            res_latex = "Error: $(e). 5*x のように入力してください"
        end
    end
end

function ui()
    [
        # LaTeX表示用のエンジン
        script(src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.7/MathJax.js?config=TeX-MML-AM_CHTML"),
        
        style("body { background: #f0f2f5; padding-top: 50px; font-family: sans-serif; }
               .card { background: white; padding: 30px; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); max-width: 500px; margin: auto; }"),

        section(class="card", [
            h2(class="text-primary text-center", "Julia 代数電卓"),
            textfield("計算したい式を入力", :input_expr, filled=true),
            
            # 確実なclickのボタン設定
            button("計算", @click("compute = true"), color="primary", class="full-width q-mt-md"),
            
            hr(class="q-my-lg"),
            p(class="text-red-7", "計算結果:"),
            # 変数の変化をリアルタイムに表示
            h3(v__text=:res_latex, class="text-secondary text-center")
        ])
    ]
end

# WSL2の接続の設定
Genie.config.server_host = "0.0.0.0"
@page("/", ui)
up(9000)
wait()
