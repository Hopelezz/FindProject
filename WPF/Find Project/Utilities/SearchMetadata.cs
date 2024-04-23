using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Find_Project.Utilities
{
    public class SearchMetadata
    {
        public string Text { get; }
        public string SearchContext { get; }

        public SearchMetadata(string text, string searchContext)
        {
            Text = text;
            SearchContext = searchContext;
        }

        public override string ToString()
        {
            return Text;
        }
    }
}
