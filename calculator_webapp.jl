# 計算ボタンは表示できるようになりましたが、それを押してもまだ答えの値が変わりません。したがって、まずはこの部分を改善する予定です。

using GenieFramework
using Symbolics
using Latexify
@genietools

@app begin
    @in input_expr = "x^2 + sin(x)"
    @in compute = false   
    @out res_latex = "2x + \\cos(x)"

    @onbutton compute begin
        compute || return        # false のときは何もしない
        compute = false          # 押下後にリセット
        try
            @variables x
            expr = Symbolics.parse(strip(input_expr))
            der = expand_derivatives(Differential(x)(expr))
            res_latex = latexify(der).s
        catch
            res_latex = "Error: 数式が不完全です"
        end
    end
end

function ui()
    [
        script(src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.7/MathJax.js?config=TeX-MML-AM_CHTML"),

        style("""
        body {
            background: #f4f7f9;
            font-family: sans-serif;
            display: flex;
            justify-content: center;
            padding-top: 50px;
        }
        .card {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 500px;
        }
        """),

        section(class="card", [
            h2(class="text-primary", "Julia 代数電卓"),

            textfield("数式を入力 (例: x^3)", :input_expr, filled=true),

            button(
                "計算",
                click = "compute",
                color="primary"
            ),
            hr(class="q-my-md"),

            p(class="text-grey-7", "微分結果:"),

            h3(v__text=:res_latex, class="text-secondary")
        ])
    ]
end


@page("/", ui)

# WSL2の壁を壊す設定
Genie.config.server_host = "0.0.0.0"
up(9000)
wait()
