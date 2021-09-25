using System;
using System.Globalization;
using System.Windows.Controls;
using System.Windows.Data;

namespace KSP.UI.Converter
{
    public class DataGridDataContextConveter : IValueConverter
    {
        #region ${Implements Interface} Members

        /// <inheritdoc />
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            var dg = value as DataGrid;
            return dg?.DataContext;
        }

        /// <inheritdoc />
        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            var dg = value as DataGrid;
            return dg?.DataContext;
        }

        #endregion
    }
}