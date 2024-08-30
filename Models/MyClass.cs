using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace task5.Models
{
    public class MyClass
    {
       
            public DateTime _CreatedOn = DateTime.Now;
            public DateTime CreatedOn
            {
                get { return _CreatedOn; }
                set { _CreatedOn = value; }
            }
        
    }
}