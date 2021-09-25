using System;
using System.Globalization;
using System.Windows;
using System.Windows.Data;

namespace KSP.UI.Converter
{
    public class IntToVisibilityConveter:IValueConverter
    {
        /// <inheritdoc />
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return value == null || int.Parse(value.ToString())  == 0 ? Visibility.Collapsed : Visibility.Visible;
        }

        /// <inheritdoc />
        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
