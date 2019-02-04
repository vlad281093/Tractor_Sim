using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ParticlesMenu : MonoBehaviour
{
    public ParticleExamples[] particleSystems;
    //public GameObject gunGameObject;
    private int currentIndex;
    private GameObject currentGO;
    public Transform spawnLocation;

    public Text title;
    public Text description;
    public Text navigationDetails;

    void Start()
    {
        Navigate(0);
        currentIndex = 0;
    }

    public void Navigate(int i)
    {

        currentIndex = (particleSystems.Length + currentIndex + i) % particleSystems.Length;

        if (currentGO != null)
            Destroy(currentGO);

        currentGO = Instantiate(particleSystems[currentIndex].particleSystemGO, spawnLocation.position + particleSystems[currentIndex].particlePosition, Quaternion.Euler(particleSystems[currentIndex].particleRotation)) as GameObject;

        //gunGameObject.SetActive(particleSystems[currentIndex].isWeaponEffect);

        title.text = particleSystems[currentIndex].title;
        description.text = particleSystems[currentIndex].description;
        navigationDetails.text = "" + (currentIndex + 1) + " out of " + particleSystems.Length.ToString();
    }
}
