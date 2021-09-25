using System.Windows;
using System.Windows.Media;

namespace KSP.UI
{
    public static class Utils
    {
        public static T FindParent<T>(DependencyObject child, DependencyObject root = null) where T : DependencyObject
        {
            if (ReferenceEquals(child, root) || !(child is Visual))
                return null;

            var parentObject = VisualTreeHelper.GetParent(child);
            if (parentObject == null)
                return null;

            if (parentObject is T parent)
                return parent;

            return FindParent<T>(parentObject);
        }
    }
}