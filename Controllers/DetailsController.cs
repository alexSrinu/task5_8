using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using task5.Models;
using static task5.Models.Details;

namespace task5.Controllers
{
    public class DetailsController : Controller
    {
     private Repository _repository = new Repository();
        private List<Details> model;

      

        [HttpGet]
        public ActionResult Index()
        {
            
            ViewBag.States = new SelectList(_repository.GetStates(), "StateId", "StateName");
            ViewBag.Cities = new SelectList(Enumerable.Empty<SelectListItem>(), "Value", "Text");
           
            var model = new Details();
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Index(Details s)
        {
            if (ModelState.IsValid)
            {
                _repository.Register(s);
                return RedirectToAction("GetDetails");
            }

           
            ViewBag.States = new SelectList(_repository.GetStates(), "StateId", "StateName");
            ViewBag.Cities = new SelectList(Enumerable.Empty<SelectListItem>(), "Value", "Text");

            return View(s);
        }

        [HttpGet]



        public JsonResult GetCitiesByStateId(int stateId)
        {
            if (stateId == 0)
            {
                return Json(new List<City>(), JsonRequestBehavior.AllowGet);
            }
            int Id;
            Id = Convert.ToInt32(stateId);

           
            var cities = _repository.GetCities(stateId);
            return Json(cities, JsonRequestBehavior.AllowGet);
        }
        public ActionResult GetDeatils1(string stateName)
        {

            var obj = TempData["Data"];
            return RedirectToAction("GetDetails", obj);
            return View();
        }
        /*  public JsonResult GetCitiesByState(string stateName)
          {

              var cities = _repository.GetCitiesByState(stateName); 

              return Json(cities, JsonRequestBehavior.AllowGet);
          }*/
        public JsonResult GetCitiesByStates(string stateNames)
        {
          
            var stateNameList = stateNames.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

            var cityGroups = new List<StateCityGroup>();

            foreach (var stateName in stateNameList)
            {
                var cities = _repository.GetCitiesByState(stateName);
                cityGroups.Add(new StateCityGroup
                {
                    StateName = stateName,
                    Cities = cities
                });
            }

            return Json(cityGroups, JsonRequestBehavior.AllowGet);
        }

       
        public class StateCityGroup
        {
            public string StateName { get; set; }
            public List<string> Cities { get; set; }
        }


       
        [HttpGet]
        public ActionResult GetDetails(
    string stateName,
    string searchString,
    string cityNames,
    DateTime? startDate,
    DateTime? endDate,
    int? pageNumber,
    int pageSize = 10)
        {
            
            int currentPage = pageNumber ?? 1;
            pageSize = pageSize > 0 ? pageSize : 10;

           
            int totalCount;
            int totalPages;

          
            IEnumerable<Details> model;

           
            if (!string.IsNullOrEmpty(stateName))
            {
                var cities = _repository.GetCitiesByState(stateName).ToList();
                ViewBag.States = _repository.GetStates();
                return Json(cities, JsonRequestBehavior.AllowGet);
            }

           
            model = _repository.GetPagedData(
                pageSize,
                currentPage,
                searchString,
                cityNames,
                startDate,
                endDate,
                out totalCount
            ).ToList();
         

           
            totalPages = (int)Math.Ceiling((double)totalCount / pageSize);

          
            var result = new PaginatedResult
            {
                Det = model,
                TotalPages = totalPages,
                PageSize = pageSize,
                TotalCount = totalCount,
                CurrentPage = currentPage
            };

         
            if (!string.IsNullOrEmpty(cityNames) || !string.IsNullOrEmpty(searchString) || startDate.HasValue || endDate.HasValue)
            {
                return Json(result, JsonRequestBehavior.AllowGet);
            }

           
            ViewBag.TotalCount = totalCount;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalPages = totalPages;
            ViewBag.CurrentPage = currentPage;
            ViewBag.States = _repository.GetStates();

           
            return View(model);
        }


        /*  [HttpGet]
            public JsonResult GetDetailsCities(string citynames)
            {
                var det = _repository.GetDetailsCities(citynames);
                return Json(det,JsonRequestBehavior.AllowGet);
            }
          [HttpGet]
          public ActionResult GetDetails(string stateName, string searchString, string cityNames, DateTime? startDate, DateTime? endDate, int? pageNumber, int pageSize = 10)
          {
              int currentPage = pageNumber ?? 1;
              int totalCount;
              int totalPages;
              IEnumerable<Details> model;


              if (!string.IsNullOrEmpty(stateName))
              {
                  var cities = _repository.GetCitiesByState(stateName).ToList();
                  ViewBag.States = _repository.GetStates();
                  return Json(cities, JsonRequestBehavior.AllowGet);
              }


              model = _repository.GetPagedData(pageSize, currentPage, searchString, cityNames, startDate, endDate, out totalCount).ToList();
              totalPages = (int)Math.Ceiling((double)totalCount / pageSize);

              var result = new PaginatedResult
              {
                  Det = model,
                  TotalPages = totalPages,
                  PageSize = pageSize,
                  TotalCount = totalCount,
                  CurrentPage = currentPage
              };

              if (!string.IsNullOrEmpty(cityNames))
              {
                  return Json(result, JsonRequestBehavior.AllowGet);
              }


              ViewBag.TotalCount = totalCount;
              ViewBag.PageSize = pageSize;
              ViewBag.TotalPages = totalPages;
              ViewBag.CurrentPage = currentPage;
              ViewBag.States = _repository.GetStates();

              return View(model); 
          }*/


        /*   [HttpGet]
           public ActionResult GetDetails(string stateName, string searchString, string cityNames, DateTime? startDate, DateTime? endDate, int? pageNumber, int pageSize = 10)
           {
               int currentPage = pageNumber ?? 1;
               int totalCount;
               int totalPages;
               IEnumerable<Details> model;


               if (!string.IsNullOrEmpty(stateName))
               {
                   var cities = _repository.GetCitiesByState(stateName).ToList();
                   ViewBag.States = _repository.GetStates();
                   return Json(cities, JsonRequestBehavior.AllowGet);
               }


               var det = _repository.GetPagedData(pageSize, currentPage, searchString, cityNames, startDate, endDate, out totalCount).ToList();
               var det1 = _repository.GetPagedData1(pageSize, currentPage, searchString, cityNames,  out totalCount).ToList();

               totalPages = (int)Math.Ceiling((double)totalCount / pageSize);

               var result = new PaginatedResult
               {
                   Det = det1,
                   TotalPages = totalPages,
                   PageSize = pageSize,
                   TotalCount = totalCount,
                   CurrentPage = currentPage
               };

               if (!string.IsNullOrEmpty(cityNames))
               {
                   return Json(result, JsonRequestBehavior.AllowGet);
               }

               ViewBag.TotalCount = totalCount;
               ViewBag.PageSize = pageSize;
               ViewBag.TotalPages = totalPages;
               ViewBag.CurrentPage = currentPage;
               ViewBag.States = _repository.GetStates();

               return View(model);
           }*/

        /*  [HttpGet]
          public ActionResult GetDetails(string stateName, string searchString, string cityNames, int? pageNumber, int pageSize = 10)
          {
              int currentPage = pageNumber ?? 1;
              int totalCount;
              int totalPages;
              IEnumerable<Details> model;


              if (!string.IsNullOrEmpty(stateName))
              {
                  var cities = _repository.GetCitiesByState(stateName).ToList();
                  ViewBag.States = _repository.GetStates();
                  return Json(cities, JsonRequestBehavior.AllowGet);
              }


              if (!string.IsNullOrEmpty(cityNames))
              {
                  var det = _repository.GetPagedData(pageSize, currentPage, searchString, cityNames, out totalCount).ToList();
                  totalPages = (int)Math.Ceiling((double)totalCount / pageSize);

                  var result = new PaginatedResult
                  {
                      Det = det,
                      TotalPages = totalPages,
                      PageSize = pageSize,
                      TotalCount = totalCount,
                      CurrentPage = currentPage
                  };

                  return Json(result, JsonRequestBehavior.AllowGet);
              }


              model = _repository.GetPagedData(pageSize, currentPage, searchString, cityNames, out totalCount).ToList();
              totalPages = (int)Math.Ceiling((double)totalCount / pageSize);

              ViewBag.TotalCount = totalCount;
              ViewBag.PageSize = pageSize;
              ViewBag.TotalPages = totalPages;
              ViewBag.CurrentPage = currentPage;
              ViewBag.States = _repository.GetStates();

              return View(model);
          }*/





        /*   [HttpGet]
           public ActionResult Edit(int id, int? pageNumber)
           {
               var detailsList = _repository.GetDetails(id);
               var details = detailsList.FirstOrDefault(emp => emp.Id == id);

               if (details == null)
               {
                   return HttpNotFound();
               }
               pageNumber = ViewBag.CurrentPage;

               ViewBag.States = new SelectList(_repository.GetStates(), "StateId", "StateName", details.StateId);
               ViewBag.Cities = new SelectList(_repository.GetCities(details.StateId), "CityId", "CityName", details.CityId);
               ViewBag.CurrentPage = pageNumber; 

               return View(details);
           }
           [HttpPost]
           public ActionResult Edit(int id, Details r, int? pageNumber)
           {
               if (ModelState.IsValid)
               {
                   _repository.Edit(id, r);
                   return RedirectToAction("GetDetails", new { Page = pageNumber }); 
               }

               ViewBag.States = new SelectList(_repository.GetStates(), "StateId", "StateName", r.StateId);
               ViewBag.Cities = new SelectList(_repository.GetCities(r.StateId), "CityId", "CityName", r.CityId);
               ViewBag.CurrentPage = pageNumber;

               return View(r);
           }*/
        [HttpGet]
          public ActionResult Edit(int id)
          {

              var detailsList = _repository.GetDetails(id);
              var details = detailsList.FirstOrDefault(emp => emp.Id == id);
              var page= TempData["Data"];

              if (details == null)
              {
                  return HttpNotFound();
              }

              ViewBag.States = new SelectList(_repository.GetStates(), "StateId", "StateName", details.StateId);
              ViewBag.Cities = new SelectList(_repository.GetCities(details.StateId), "CityId", "CityName", details.CityId);
           
              return View(details);
          }

          [HttpPost]
          public ActionResult Edit(int id, Details r)
          {
              if (ModelState.IsValid)
              {
                  _repository.Edit(id, r);
                  return RedirectToAction("GetDetails");
              }

              ViewBag.States = new SelectList(_repository.GetStates(), "StateId", "StateName", r.StateId);
              ViewBag.Cities = new SelectList(_repository.GetCities(r.StateId), "CityId", "CityName", r.CityId);

              return View(r);
          }




        [HttpPost]
        public ActionResult Delete(int id)
        {
            if (ModelState.IsValid)
            {
                _repository.Delete(id);
                return RedirectToAction("GetDetails");
            }
            return View();
        }



    }



}
