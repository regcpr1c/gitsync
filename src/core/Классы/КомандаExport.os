﻿///////////////////////////////////////////////////////////////////
//
// Служебный модуль с реализацией работы команды export
//
// Представляет собой модификацию приложения gitsync от 
// команды oscript-library
//
// Идея формата модуля взята из проекта deployka
//
///////////////////////////////////////////////////////////////////

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, "Выполнить локальную синхронизацию, без pull/push");
	
	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "ПутьКХранилищу", "Файловый путь к каталогу хранилища конфигурации 1С.");
	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "ЛокальныйКаталогГит", "Каталог исходников внутри локальной копии git-репозитария.");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-email", "<домен почты для пользователей git>");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-v8version", "<Маска версии платформы (8.3, 8.3.5, 8.3.6.2299 и т.п.)>");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-debug", "<on|off>");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-verbose", "<on|off>");
    Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-format", "<hierarchical|plain>");
    Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-minversion", "<номер минимальной версии для выгрузки>");
    Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-maxversion", "<номер максимальной версии для выгрузки>");
    Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-limit", "<выгрузить неболее limit версий от текущей выгруженной>");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-tempdir", "<Путь к каталогу временных файлов>");

	Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры // ЗарегистрироватьКоманду

Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры) Экспорт
    
	Парсер = Новый ПарсерАргументовКоманднойСтроки;

	МенеджерКомандПриложения.ЗарегистрироватьКоманды(Парсер);

	Если ПараметрыКоманды["Команда"] = Неопределено Тогда

		ПоказатьВозможныеКоманды(Парсер);

	Иначе
		
		ПоказатьСправкуПоКоманде(Парсер, ПараметрыКоманды["Команда"]);

	КонецЕсли;

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;

КонецФункции // ВыполнитьКоманду

Процедура ПоказатьВозможныеКоманды(Знач Парсер)
	
	ВозможныеКоманды = Парсер.СправкаВозможныеКоманды();
	Сообщить("Возможные команды:");
	
	МаксШирина = 0;
	Для Каждого Команда Из ВозможныеКоманды Цикл
		
		МаксШирина = Макс(МаксШирина, СтрДлина(Команда.Команда));
		
	КонецЦикла;
	
	Поле = "               ";	
	Для Каждого Команда Из ВозможныеКоманды Цикл

		Сообщить(" " + Лев(Команда.Команда + Поле, МаксШирина + 2) + "- " + Команда.Пояснение);

	КонецЦикла;
			
	Сообщить("Для подсказки по конкретной команде наберите help <команда>");

КонецПроцедуры // ПоказатьВозможныеКоманды

Процедура ПоказатьСправкуПоКоманде(Знач Парсер, Знач ИмяКоманды)

	ВозможныеКоманды = Парсер.СправкаВозможныеКоманды();
	ОписаниеКоманды = ВозможныеКоманды.Найти(ИмяКоманды, "Команда");
	Если ОписаниеКоманды = Неопределено Тогда
		Сообщить("Команда отсуствует: " + ИмяКоманды);
		Возврат;
	КонецЕсли;
	
	Сообщить("" + ОписаниеКоманды.Команда + " - " + ОписаниеКоманды.Пояснение);
	ВывестиПараметры(ОписаниеКоманды.Параметры);

КонецПроцедуры // ПоказатьСправкуПоКоманде

Процедура ВывестиПараметры(Знач ОписаниеПараметров)
	
	Сообщить("Параметры:");
	Для Каждого СтрПараметр Из ОписаниеПараметров Цикл

		Если Не СтрПараметр.ЭтоИменованныйПараметр Тогда

			Сообщить(СтрШаблон(" <%1> - %2", СтрПараметр.Имя, СтрПараметр.Пояснение));

		Иначе
			
			Сообщить(СтрШаблон(" %1 - %2", СтрПараметр.Имя, СтрПараметр.Пояснение));

		КонецЕсли;

	КонецЦикла;
	
КонецПроцедуры // ВывестиПараметры
