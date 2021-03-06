.. index:: ! pstext

pstext
======

:官方文档: :ref:`gmt:pstext`
:简介: 在图上写文本

该命令用于在图上添加文本。可以自由控制文本的大小、颜色、字体、角度。

通过使用转义字符、特殊字体以及八进制码，还可以实现希腊字母、上下标等功能，详见 :ref:`doc:text` 、 :ref:`doc:character-escape` 、 :ref:`doc:special-fonts` 和 :ref:`doc:special-characters` 。

选项
----

``<textfiles>``
    默认情况下，输入数据的格式为::

        X  Y  text

    如果使用了 ``-F`` 选项，则输入数据的格式为::

        x  y  [font  angle  justify]  text

    其中，括号内的三项是否存在以及三项的顺序由 ``-F`` 选项决定。

``-A``
    默认情况下， ``angel`` 是指沿水平方向逆时针旋转的角度。 ``-A`` 选项表明 ``angle`` 是方位角，即相对于北向顺时针旋转的角度。

``-C<dx>/<dy>``
    设置文本框与文本之间的空白区域，默认值为字体大小的15%。

    ``<dx>`` 可以是具体的距离值也可以接 ``%`` 表示空白与当前字号的百分比。例如 ``-C1c/1c`` 或 ``-C20%/30%`` 。

    下图展示了文本与文本框之间的空隙。

    .. figure:: /images/GMT_pstext_clearance.*
       :width: 400 px
       :align: center

``-D[j|J]<dx>[/<dy>][v<[pen>]]``
    文本在指定坐标的基础上偏移 ``<dx>/<dy>`` ，默认值为 ``0/0`` ，即不偏移。

    使用pstext经常遇到的情况是在台站处标记台站名，此时传递给pstext的位置参数通常是台站坐标，因而pstext会将文本置于台站坐标处，该选择用于将文本稍稍偏离台站坐标位置以避免文本挡住台站处的符号。

    #. 若不指定 ``<dy>`` ，则默认 ``<dy>=<dx>``
    #. ``-Dj`` 见官方文档
    #. ``-DJ`` 见官方文档
    #. 偏移量后加上 ``v`` 表示绘制一条连接初始位置与偏移后位置的直线
    #. ``v<pen>`` 控制连线的画笔属性

``-F[+a[angle]][+c[justify]][+f[font]][+h][+j[justify]][+l]``
    控制文本的角度、对齐方式和字体等属性。

    #. ``+f<font>`` 设置文本的字体， 见 :ref:`doc:text`
    #. ``+a<angle>`` 文本相对于水平方向逆时针旋转的角度
    #. ``+j<justify>`` 文本对齐方式，见 :ref:`doc:anchors`

    下面的命令中，统一设置了所有文本的字号为30p，4号字体，红色，文本旋转45度，且以左上角对齐::

        gmt pstext -R0/10/0/10 -JX10c/10c -B1g1 -F+f30p,4,red+a45+jTL > text.ps << EOF
        3 4 Text1
        6 8 Text2
        EOF

    若使用了 ``+f`` 子选项，但是未给定 ``<font>`` ，则意味着输入数据的每一行需要自定义本行的字体属性，因为输入数据的格式要发生变化。例如 ``-F+f`` 选项要求的输入数据的格式为::

        x   y   font    text

    对于 ``+a`` 和 ``+j`` 同理。若 ``+f`` 、 ``+a`` 、 ``+j`` 中有两个以上未在命令行中指定参数，则输入数据中要增加多列，每列的顺序由这三个子选项的相对顺序决定。比如 ``-F+f+a`` 的输入数据格式是::

        x   y   font   angle  text

    ``-F+a+f`` 的输入数据格式为::

        x   y   angle  font   text

    ``-F+f+j+a`` 表示所有数据都需要单独指定字体、对齐方式和角度，此时输入数据的格式为::

        x   y   font    justification   angle    text

    ``-F+a+j+f`` 与前一个例子类似，唯一的区别在于子选项的顺序不同，而输入数据的格式要与子选项的顺序相匹配，此时输入数据的格式为::

        x   y   angle   justification   font    text

    ``-F+f12p,Helvetica-Bold,red+j+a`` 为所有行设置了统一的字体，但每一行需要单独指定对齐方式和角度，此时输入数据的格式为::

        x   y   justification   angle   text

    使用 ``+c<justify>`` 选项，则输入数据中不需要XY坐标，只需要文本即可，该选项直接从 ``-R`` 选项中提取出范围信息，并由对齐方式决定文本的坐标位置。比如 ``-F+cTL`` 表示将文本放在底图的左上角，在加上合适的偏移量即可放在任意位置。例如::

        echo '(a)' | gmt pstext -R0/10/0/10 -JX10c/10c -B1 -F+cTL -Dj0.2c/0.2c > text.ps

    ``+h`` 会直接从多段数据的段头记录中提取文本::

        gmt pstext -R0/10/0/10 -JX10c/10c -B1 -F+h > text.ps << EOF
        > TEXT1
        2  2
        > TEXT2
        5  5
        EOF

    ``+l`` 会直接从多段数据的段头记录里的 ``-L<label>`` 中提取信息::

        gmt pstext -R0/10/0/10 -JX10c/10c -B1 -F+h > text.ps << EOF
        > -LTEXT1
        2  2
        > -LTEXT2
        5  5
        EOF

``-G``
    设置文本框的填充色。

    除了设置填充色之外， ``-G`` 选项还有两个高级用法，即 ``-Gc`` 和 ``-GC`` 。其中， ``-Gc`` 表示先绘制文本，然后将文本框裁剪出来，并打开裁剪选项，之后的绘图命令都不会覆盖文本所在区域，最后需要使用 :doc:`psclip` 的 ``-C`` 选项关闭裁剪。若不想要绘制文本只想要激活裁剪选项，可以使用 ``-GC`` 选项。

``-L``
    用于列出GMT所支持的所有字体名及其对应的字号::

        gmt pstext -L

``-M``
    段落模式，用于输入大量文本。

    输入文件必须是多段数据。数据段头记录的格式为::

        > X Y [font angle justify] linespace parwidth parjust

    #. 第一个字符是数据段开始标识符，默认为 ``>``
    #. 从第三列开始，包含了本段文本的设置信息
    #. ``font angle justify`` 是可选的，由 ``-F`` 选项控制
    #. ``linespace`` 行间距
    #. ``parwidth`` 段落宽度
    #. ``parjust`` 段落对齐方式，可以取为 ``l`` （左对齐）、 ``c`` （居中对齐）、 ``r`` （右对齐）、 ``j`` （分散对齐）

    段头记录后即为要显示在图上的文本，每段数据之间用空行分隔。

    .. literalinclude:: ../scripts/pstext_-M.sh
       :language: bash

    .. figure:: /images/pstext_-M.*
       :width: 600px
       :align: center

       段落模式示意图

``-N``
    位于地图边界外的文本也被绘制。

    默认情况下，若文本超过了底图边框，则不显示该文本，即文本被裁剪掉了。使用 ``-N`` 选项，即便文本超出了底图边框的范围，也依然会显示。

``-Ql|u``
    所有文本以小写（lower case）或大写（upper case）显示

``-To|O|c|C``
    设置文本框的形状

    #. ``-To`` ：直角矩形
    #. ``-TO`` ：圆角矩形
    #. ``-Tc`` ：凹矩形（与 ``-M`` 选项一起使用）
    #. ``-TC`` ：凸矩形（与 ``-M`` 选项一起使用）

``-W<pen>``
    设置文本框的边框属性，默认值为 ``default,black,solid``

``-Z``
    3D投影中，需要在数据的第三列指定文本的Z位置，数据格式为::

        X   Y   Z   Text

    此时强制使用 ``-N`` 选项。

示例
----

下面的例子中设置文本框的相关属性：蓝色边框、淡蓝填充色、圆角矩形，空白为 ``100%/100%`` ::

    gmt pstext -R0/10/0/5 -JX10c/5c -B1 -Wblue -Glightblue -TO -C100%/100% > text.ps << EOF
    3   1   Text1
    6   3   Text2
    EOF
