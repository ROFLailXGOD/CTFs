.class Llu/hack/Flagdroid/MainActivity$1;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Llu/hack/Flagdroid/MainActivity;->onCreate(Landroid/os/Bundle;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Llu/hack/Flagdroid/MainActivity;


# direct methods
.method constructor <init>(Llu/hack/Flagdroid/MainActivity;)V
    .locals 0

    .line 39
    iput-object p1, p0, Llu/hack/Flagdroid/MainActivity$1;->this$0:Llu/hack/Flagdroid/MainActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 9

    .line 41
    iget-object p1, p0, Llu/hack/Flagdroid/MainActivity$1;->this$0:Llu/hack/Flagdroid/MainActivity;

    const v0, 0x7f0700ec

    invoke-virtual {p1, v0}, Llu/hack/Flagdroid/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    .line 42
    iget-object v0, p0, Llu/hack/Flagdroid/MainActivity$1;->this$0:Llu/hack/Flagdroid/MainActivity;

    const v1, 0x7f0700eb

    invoke-virtual {v0, v1}, Llu/hack/Flagdroid/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    .line 43
    iget-object v1, p0, Llu/hack/Flagdroid/MainActivity$1;->this$0:Llu/hack/Flagdroid/MainActivity;

    const v2, 0x7f0700c4

    invoke-virtual {v1, v2}, Llu/hack/Flagdroid/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/EditText;

    .line 45
    invoke-virtual {v1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v1

    .line 47
    invoke-virtual {v1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "flag\\{(.*)\\}"

    .line 48
    invoke-static {v2}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v2

    .line 49
    invoke-virtual {v2, v1}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v1

    .line 50
    invoke-virtual {v1}, Ljava/util/regex/Matcher;->find()Z

    move-result v2

    const/4 v3, 0x4

    const/4 v4, 0x0

    if-eqz v2, :cond_0

    .line 51
    invoke-virtual {v1}, Ljava/util/regex/Matcher;->group()Ljava/lang/String;

    move-result-object v1

    const-string v2, "flag{"

    const-string v5, ""

    invoke-virtual {v1, v2, v5}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "}"

    invoke-virtual {v1, v2, v5}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "_"

    .line 53
    invoke-virtual {v1, v2}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    .line 54
    array-length v2, v1

    if-ne v2, v3, :cond_0

    .line 55
    iget-object v2, p0, Llu/hack/Flagdroid/MainActivity$1;->this$0:Llu/hack/Flagdroid/MainActivity;

    aget-object v5, v1, v4

    invoke-static {v2, v5}, Llu/hack/Flagdroid/MainActivity;->access$000(Llu/hack/Flagdroid/MainActivity;Ljava/lang/String;)Z

    move-result v2

    .line 56
    iget-object v5, p0, Llu/hack/Flagdroid/MainActivity$1;->this$0:Llu/hack/Flagdroid/MainActivity;

    const/4 v6, 0x1

    aget-object v6, v1, v6

    invoke-static {v5, v6}, Llu/hack/Flagdroid/MainActivity;->access$100(Llu/hack/Flagdroid/MainActivity;Ljava/lang/String;)Z

    move-result v5

    .line 57
    iget-object v6, p0, Llu/hack/Flagdroid/MainActivity$1;->this$0:Llu/hack/Flagdroid/MainActivity;

    const/4 v7, 0x2

    aget-object v7, v1, v7

    invoke-static {v6, v7}, Llu/hack/Flagdroid/MainActivity;->access$200(Llu/hack/Flagdroid/MainActivity;Ljava/lang/String;)Z

    move-result v6

    .line 58
    iget-object v7, p0, Llu/hack/Flagdroid/MainActivity$1;->this$0:Llu/hack/Flagdroid/MainActivity;

    const/4 v8, 0x3

    aget-object v1, v1, v8

    invoke-static {v7, v1}, Llu/hack/Flagdroid/MainActivity;->access$300(Llu/hack/Flagdroid/MainActivity;Ljava/lang/String;)Z

    move-result v1

    if-eqz v2, :cond_0

    if-eqz v5, :cond_0

    if-eqz v6, :cond_0

    if-eqz v1, :cond_0

    .line 61
    invoke-virtual {p1, v3}, Landroid/widget/TextView;->setVisibility(I)V

    .line 62
    invoke-virtual {v0, v4}, Landroid/widget/TextView;->setVisibility(I)V

    return-void

    .line 67
    :cond_0
    invoke-virtual {p1, v4}, Landroid/widget/TextView;->setVisibility(I)V

    .line 68
    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setVisibility(I)V

    return-void
.end method
