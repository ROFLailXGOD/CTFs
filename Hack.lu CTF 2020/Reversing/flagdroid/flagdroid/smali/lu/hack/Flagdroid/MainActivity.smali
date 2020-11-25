.class public Llu/hack/Flagdroid/MainActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "MainActivity.java"


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const-string v0, "native-lib"

    .line 22
    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 19
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    return-void
.end method

.method static synthetic access$000(Llu/hack/Flagdroid/MainActivity;Ljava/lang/String;)Z
    .locals 0

    .line 19
    invoke-direct {p0, p1}, Llu/hack/Flagdroid/MainActivity;->checkSplit1(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method static synthetic access$100(Llu/hack/Flagdroid/MainActivity;Ljava/lang/String;)Z
    .locals 0

    .line 19
    invoke-direct {p0, p1}, Llu/hack/Flagdroid/MainActivity;->checkSplit2(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method static synthetic access$200(Llu/hack/Flagdroid/MainActivity;Ljava/lang/String;)Z
    .locals 0

    .line 19
    invoke-direct {p0, p1}, Llu/hack/Flagdroid/MainActivity;->checkSplit3(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method static synthetic access$300(Llu/hack/Flagdroid/MainActivity;Ljava/lang/String;)Z
    .locals 0

    .line 19
    invoke-direct {p0, p1}, Llu/hack/Flagdroid/MainActivity;->checkSplit4(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method private checkSplit1(Ljava/lang/String;)Z
    .locals 4

    .line 75
    invoke-virtual {p0}, Llu/hack/Flagdroid/MainActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const v1, 0x7f0c001e

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x0

    invoke-static {v0, v1}, Landroid/util/Base64;->decode(Ljava/lang/String;I)[B

    move-result-object v0

    .line 77
    :try_start_0
    new-instance v2, Ljava/lang/String;

    const-string v3, "UTF-8"

    invoke-direct {v2, v0, v3}, Ljava/lang/String;-><init>([BLjava/lang/String;)V

    .line 78
    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1
    :try_end_0
    .catch Ljava/io/UnsupportedEncodingException; {:try_start_0 .. :try_end_0} :catch_0

    return p1

    :catch_0
    return v1
.end method

.method private checkSplit2(Ljava/lang/String;)Z
    .locals 7

    const-string v0, "\u001fTT:\u001f5\u00f1HG"

    const/4 v1, 0x0

    .line 131
    :try_start_0
    invoke-virtual {p1}, Ljava/lang/String;->toCharArray()[C

    move-result-object p1

    const-string v2, "hack.lu20"

    const-string v3, "UTF-8"

    .line 132
    invoke-virtual {v2, v3}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object v2

    .line 134
    array-length v3, p1

    const/16 v4, 0x9

    if-eq v3, v4, :cond_0

    return v1

    :cond_0
    const/4 v3, 0x0

    :goto_0
    if-ge v3, v4, :cond_1

    .line 140
    aget-char v5, p1, v3

    add-int/2addr v5, v3

    int-to-char v5, v5

    aput-char v5, p1, v3

    .line 141
    aget-char v5, p1, v3

    aget-byte v6, v2, v3

    xor-int/2addr v5, v6

    int-to-char v5, v5

    aput-char v5, p1, v3

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 143
    :cond_1
    invoke-static {p1}, Ljava/lang/String;->valueOf([C)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1
    :try_end_0
    .catch Ljava/io/UnsupportedEncodingException; {:try_start_0 .. :try_end_0} :catch_0

    return p1

    :catch_0
    return v1
.end method

.method private checkSplit3(Ljava/lang/String;)Z
    .locals 3

    .line 152
    invoke-virtual {p1}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object p1

    .line 153
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    const/4 v1, 0x0

    const/16 v2, 0x8

    if-eq v0, v2, :cond_0

    return v1

    :cond_0
    const/4 v0, 0x4

    .line 155
    invoke-virtual {p1, v1, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    const-string v2, "h4rd"

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    return v1

    .line 158
    :cond_1
    invoke-static {p1}, Llu/hack/Flagdroid/MainActivity;->md5(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    const-string v0, "6d90ca30c5de200fe9f671abb2dd704e"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    return p1
.end method

.method private checkSplit4(Ljava/lang/String;)Z
    .locals 1

    .line 163
    invoke-virtual {p0}, Llu/hack/Flagdroid/MainActivity;->stringFromJNI()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    return p1
.end method

.method public static md5(Ljava/lang/String;)Ljava/lang/String;
    .locals 7

    :try_start_0
    const-string v0, "MD5"

    .line 171
    invoke-static {v0}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v0

    .line 172
    invoke-virtual {p0}, Ljava/lang/String;->getBytes()[B

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/security/MessageDigest;->update([B)V

    .line 173
    invoke-virtual {v0}, Ljava/security/MessageDigest;->digest()[B

    move-result-object p0

    .line 176
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 177
    array-length v1, p0

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v1, :cond_1

    aget-byte v4, p0, v3

    .line 178
    new-instance v5, Ljava/lang/StringBuilder;

    and-int/lit16 v4, v4, 0xff

    invoke-static {v4}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v4

    invoke-direct {v5, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 179
    :goto_1
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->length()I

    move-result v4

    const/4 v6, 0x2

    if-ge v4, v6, :cond_0

    const-string v4, "0"

    .line 180
    invoke-virtual {v5, v2, v4}, Ljava/lang/StringBuilder;->insert(ILjava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_1

    .line 181
    :cond_0
    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/CharSequence;)Ljava/lang/StringBuilder;

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 183
    :cond_1
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_0
    .catch Ljava/security/NoSuchAlgorithmException; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    move-exception p0

    .line 186
    invoke-virtual {p0}, Ljava/security/NoSuchAlgorithmException;->printStackTrace()V

    const-string p0, ""

    return-object p0
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 2

    .line 29
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    const p1, 0x7f0a001c

    .line 30
    invoke-virtual {p0, p1}, Llu/hack/Flagdroid/MainActivity;->setContentView(I)V

    const p1, 0x7f0700ec

    .line 32
    invoke-virtual {p0, p1}, Llu/hack/Flagdroid/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    const v0, 0x7f0700eb

    .line 33
    invoke-virtual {p0, v0}, Llu/hack/Flagdroid/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    const/4 v1, 0x4

    .line 35
    invoke-virtual {p1, v1}, Landroid/widget/TextView;->setVisibility(I)V

    .line 36
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V

    const p1, 0x7f070057

    .line 38
    invoke-virtual {p0, p1}, Llu/hack/Flagdroid/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/Button;

    .line 39
    new-instance v0, Llu/hack/Flagdroid/MainActivity$1;

    invoke-direct {v0, p0}, Llu/hack/Flagdroid/MainActivity$1;-><init>(Llu/hack/Flagdroid/MainActivity;)V

    invoke-virtual {p1, v0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-void
.end method

.method public native stringFromJNI()Ljava/lang/String;
.end method
