using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Reflection;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;

namespace KSP.UI
{
    /// <summary>
    /// Логика взаимодействия для GridControl.xaml
    /// </summary>
    public partial class GridControl : UserControl
    {
        private ICollectionView view;
        private object loker = new object();
        public GridControl()
        {
          
            InitializeComponent();
            view = CollectionViewSource.GetDefaultView(DataGrid.ItemsSource);
            DataGrid.AutoGeneratedColumns += OnAutoGeneratedColumns;
        }
        private void Localization(IEnumerable<Attribute> attributes, int index)
        {
            var display = attributes.FirstOrDefault(q => q?.GetType() == typeof(DisplayAttribute)) as DisplayAttribute;
            var name = display?.GetName();
            if (!string.IsNullOrWhiteSpace(name))
            {
                DataGrid.Columns[index].Header = name;
            }
        }

        private void FormatColumn(Type type, int index)
        {
            
            if(type == typeof(DateTime))
            {
                var column = DataGrid.Columns[index] as DataGridTextColumn;
                if (column != null)
                    column.Binding.StringFormat = "dd.MM.yyyy";
            }
        }
        private void OnAutoGeneratedColumns(object sender, EventArgs eventArgs)
        {
          
            var type = DataGrid.ItemsSource.GetType().GetElementType();
            var propertys = type.GetProperties();
            lock (loker)
            {
                foreach (var property in propertys)
                {
                   
                    
                    var targetColumn = DataGrid.Columns.FirstOrDefault(c => (string) c.Header == property.Name);
                    var index = DataGrid.Columns.IndexOf(targetColumn);

                    FormatColumn(GetType(property.PropertyType), index);
                    var atts = property.GetCustomAttributes();
                    if ( atts.Count()!=0) Localization(atts, index);


                    if (atts.FirstOrDefault(q => q?.GetType() == typeof(BrowsableAttribute)) is BrowsableAttribute browsabl && !browsabl.Browsable)
                    {
                        DataGrid.Columns[index].Visibility = Visibility.Collapsed;
                    }

                }

            }
            Type GetType(Type type)
            {
                return type.IsGenericType && type.GetGenericTypeDefinition() == typeof(Nullable<>)
                    ? Nullable.GetUnderlyingType(type)
                    : type;
            }

        }
    }
}
