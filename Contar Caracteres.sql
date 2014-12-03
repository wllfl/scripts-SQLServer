CREATE FUNCTION CountCaracter
(
      @Palavra Varchar(100), @String Varchar(Max)
)
RETURNS int AS
BEGIN
 
      Declare @Count int, @CountTexto int
      Set @CountTexto = 0
      Set @Count = 0
      While @Count <= Len(@String)
      Begin
            Set @CountTexto =
            Case When Substring(@String, @Count, Len(@Palavra)) = @Palavra
                        Then @CountTexto + 1
                        Else @CountTexto
                  End
            Set @Count = @Count + 1
 
      End
      Return @CountTexto
 
END