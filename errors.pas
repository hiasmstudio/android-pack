unit Errors;

interface

const
   ER_SYNTAX            = 'Ошибка синтаксиса';

   ER_FUNC_ARGS         = 'Ошибка чтения аргументов %s: ';
   ER_FUNC_ARGS_OPEN    = ER_FUNC_ARGS + 'ожидается символ (';
   ER_FUNC_ARGS_CLOSE   = ER_FUNC_ARGS + 'ожидается символ )';
   ER_FUNC_ARGS_INVALID = ER_FUNC_ARGS + 'ожидается переменная или выражение';
   ER_FUNC_ARGS_SYNTAX  = ER_FUNC_ARGS + 'синтаксическая ошибка';
   ER_FUNC_ARGS_COUNT   = ER_FUNC_ARGS + 'неверное количество. Ожидается аргументов: %d';

   ER_FOR               = 'Ошибка оператора for: ';
   ER_FOR_EXP_EXISTS    =  ER_FOR + 'ожидается выражение';
   ER_FOR_VAR_LOC       =  ER_FOR + 'ожидается имя локальной переменной';

   ER_LEX_NOT_FOUND     = 'Лексема %s не найдена';
   ER_SYMBOL_EXISTS     = 'Ожидается символ %s';

   ER_OBJ_FIELD_ACCESS  = 'Ошибка доступа к полям объекта %s: ожидается оператор .';
   ER_OBJ_METHOD_BAD    = 'Метод %s для объекта %s не поддерживается';

   ER_VAR_EXISTS        = 'Переменная с именем %s уже существует';
   ER_VAR_NOT_FOUND     = 'Переменная с именем %s не найдена';

   ER_TOK_DNT_SUP       = 'Символ с кодом 0x%s в позиции %d не поддерживается';

implementation

end.
